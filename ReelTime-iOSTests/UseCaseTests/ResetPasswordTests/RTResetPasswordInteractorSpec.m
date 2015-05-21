#import "RTTestCommon.h"

#import "RTResetPasswordInteractor.h"
#import "RTResetPasswordInteractorDelegate.h"

#import "RTResetPasswordDataManager.h"
#import "RTResetPasswordValidator.h"

#import "RTCurrentUserService.h"
#import "RTClientCredentialsService.h"

#import "RTClientCredentials.h"

#import "RTErrorFactory.h"
#import "RTResetPasswordError.h"

SpecBegin(RTResetPasswordInteractor)

describe(@"reset password interactor", ^{
    
    __block RTResetPasswordInteractor *interactor;
    __block id<RTResetPasswordInteractorDelegate> delegate;
    
    __block RTResetPasswordDataManager *dataManager;
    __block RTResetPasswordValidator *validator;

    __block RTCurrentUserService *currentUserService;
    __block RTClientCredentialsService *clientCredentialsService;

    __block RTClientCredentials *clientCredentials;
    
    __block MKTArgumentCaptor *callbackCaptor;
    __block MKTArgumentCaptor *errorCaptor;
    
    void (^expectResetPasswordErrorCode)(RTResetPasswordError) = ^(RTResetPasswordError errorCode) {
        NSArray *errors = [errorCaptor value];
        expect(errors).to.haveACountOf(1);
        expect(errors[0]).to.beError(RTResetPasswordErrorDomain, errorCode);
    };
    
    void (^expectEmailError)(RTResetPasswordError) = ^(RTResetPasswordError errorCode) {
        [verify(delegate) resetPasswordEmailFailedWithErrors:[errorCaptor capture]];
        expectResetPasswordErrorCode(errorCode);
    };

    void (^expectResetError)(RTResetPasswordError) = ^(RTResetPasswordError errorCode) {
        [verify(delegate) resetPasswordFailedWithErrors:[errorCaptor capture]];
        expectResetPasswordErrorCode(errorCode);
    };
    
    beforeEach(^{
        clientCredentialsService = mock([RTClientCredentialsService class]);
        currentUserService = mock([RTCurrentUserService class]);
        
        validator = mock([RTResetPasswordValidator class]);
        dataManager = mock([RTResetPasswordDataManager class]);

        delegate = mockProtocol(@protocol(RTResetPasswordInteractorDelegate));
        interactor = [[RTResetPasswordInteractor alloc] initWithDelegate:delegate
                                                             dataManager:dataManager
                                                               validator:validator
                                                      currentUserService:currentUserService
                                                clientCredentialsService:clientCredentialsService];
        
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                             clientSecret:clientSecret];
        
        callbackCaptor = [[MKTArgumentCaptor alloc] init];
        errorCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"send reset password email", ^{
        it(@"missing username", ^{
            [interactor sendResetPasswordEmailForUsername:BLANK];
            expectEmailError(RTResetPasswordErrorMissingUsername);
        });
        
        it(@"should notify delegate when email is sent", ^{
            [interactor sendResetPasswordEmailForUsername:username];
            [verify(dataManager) submitRequestForResetPasswordEmailForUsername:username
                                                                     emailSent:[callbackCaptor capture]
                                                                   emailFailed:anything()];
            
            [verifyCount(delegate, never()) resetPasswordEmailSent];
            
            NoArgsCallback callback = [callbackCaptor value];
            callback();
            
            [verify(delegate) resetPasswordEmailSent];
        });
        
        it(@"should forward email errors to delegate", ^{
            [interactor sendResetPasswordEmailForUsername:username];
            [verify(dataManager) submitRequestForResetPasswordEmailForUsername:username
                                                                     emailSent:anything()
                                                                   emailFailed:[callbackCaptor capture]];

            ArrayCallback callback = [callbackCaptor value];
            NSError *error = [RTErrorFactory resetPasswordErrorWithCode:RTResetPasswordErrorEmailFailure];
            
            callback(@[error]);
            expectEmailError(RTResetPasswordErrorEmailFailure);
        });
    });
    
    describe(@"reset password", ^{
        
        context(@"registered client", ^{
            void (^givenValid)(BOOL) = ^(BOOL valid) {
                [[given([validator validateCode:resetCode username:username password:password confirmationPassword:password errors:nil]) withMatcher:anything() forArgument:4]
                 willReturnBool:valid];
            };
            
            void (^givenClientCredentials)(RTClientCredentials *) = ^(RTClientCredentials *credentials) {
                [given([currentUserService clientCredentialsForCurrentUser]) willReturn:credentials];
            };
        
            it(@"validation errors", ^{
                givenValid(NO);
                [interactor resetPasswordForCurrentClientWithCode:resetCode username:username password:password confirmationPassword:password];
                [verify(delegate) resetPasswordFailedWithErrors:anything()];
            });
            
            it(@"unknown client", ^{
                givenValid(YES);
                givenClientCredentials(nil);
                
                [interactor resetPasswordForCurrentClientWithCode:resetCode username:username password:password confirmationPassword:password];
                expectResetError(RTResetPasswordErrorUnknownClient);
            });
            
            it(@"should forward data manager errors to delegate", ^{
                givenValid(YES);
                givenClientCredentials(clientCredentials);
                
                [interactor resetPasswordForCurrentClientWithCode:resetCode username:username password:password confirmationPassword:password];
                
                [verify(dataManager) resetPasswordToNewPassword:password
                                                    forUsername:username
                                              clientCredentials:clientCredentials
                                                       withCode:resetCode
                                           passwordResetSuccess:anything()
                                                        failure:[callbackCaptor capture]];
                
                ArrayCallback callback = [callbackCaptor value];
                NSError *error = [RTErrorFactory resetPasswordErrorWithCode:RTResetPasswordErrorInvalidResetCode];

                callback(@[error]);
                expectResetError(RTResetPasswordErrorInvalidResetCode);
            });

            it(@"successful reset", ^{
                givenValid(YES);
                givenClientCredentials(clientCredentials);
                
                [interactor resetPasswordForCurrentClientWithCode:resetCode username:username password:password confirmationPassword:password];
                
                [verify(dataManager) resetPasswordToNewPassword:password
                                                    forUsername:username
                                              clientCredentials:clientCredentials
                                                       withCode:resetCode
                                                       passwordResetSuccess:[callbackCaptor capture]
                                                        failure:anything()];

                [verifyCount(delegate, never()) resetPasswordSucceeded];

                NoArgsCallback callback = [callbackCaptor value];
                callback();
                
                [verify(delegate) resetPasswordSucceeded];
            });
        });
        
        context(@"new client", ^{
            void (^givenValid)(BOOL) = ^(BOOL valid) {
                [[given([validator validateCode:resetCode username:username password:password confirmationPassword:password clientName:clientName errors:nil]) withMatcher:anything() forArgument:5]
                 willReturnBool:valid];
            };
            
            it(@"validation errors", ^{
                givenValid(NO);
                [interactor resetPasswordForNewClientWithClientName:clientName code:resetCode username:username password:password confirmationPassword:password];
                [verify(delegate) resetPasswordFailedWithErrors:anything()];
            });
            
            describe(@"storing new client credentials", ^{
                
                __block MKTArgumentCaptor *successCaptor;
                __block MKTArgumentCaptor *failureCaptor;
                
                __block MKTArgumentCaptor *resetFailureCaptor;
                
                beforeEach(^{
                    givenValid(YES);
                    
                    resetFailureCaptor = [[MKTArgumentCaptor alloc] init];
                    
                    [interactor resetPasswordForNewClientWithClientName:clientName code:resetCode username:username password:password confirmationPassword:password];
                    
                    [verify(dataManager) resetPasswordToNewPassword:password
                                                        forUsername:username
                                                           withCode:resetCode
                                    registerNewClientWithClientName:clientName
                                                           passwordResetSuccess:[callbackCaptor capture]
                                                            failure:[resetFailureCaptor capture]];
                    
                    [verifyCount(clientCredentialsService, never()) saveClientCredentials:anything()
                                                                              forUsername:anything()
                                                                                  success:anything()
                                                                                  failure:anything()];
                    
                    [verifyCount(delegate, never()) resetPasswordSucceeded];
                    
                    ClientCredentialsCallback callback = [callbackCaptor value];
                    callback(clientCredentials);
                    
                    successCaptor = [[MKTArgumentCaptor alloc] init];
                    failureCaptor = [[MKTArgumentCaptor alloc] init];
                    
                    [verify(clientCredentialsService) saveClientCredentials:clientCredentials
                                                                forUsername:username
                                                                    success:[successCaptor capture]
                                                                    failure:[failureCaptor capture]];
                });
                
                it(@"should forward data manager errors to delegate", ^{
                    ArrayCallback callback = [resetFailureCaptor value];
                    NSError *error = [RTErrorFactory resetPasswordErrorWithCode:RTResetPasswordErrorInvalidResetCode];
                    
                    callback(@[error]);
                    expectResetError(RTResetPasswordErrorInvalidResetCode);
                });
                
                it(@"store new client credentials on successful reset", ^{
                    NoArgsCallback successCallback = [successCaptor value];
                    successCallback();
                    [verify(delegate) resetPasswordSucceeded];
                });
                
                it(@"failed to save client credentials on reset", ^{
                    NoArgsCallback failureCallback = [failureCaptor value];
                    failureCallback();
                    expectResetError(RTResetPasswordErrorFailedToSaveClientCredentials);
                });
            });
        });
    });
    
    describe(@"data manager delegate", ^{

    });
});

SpecEnd