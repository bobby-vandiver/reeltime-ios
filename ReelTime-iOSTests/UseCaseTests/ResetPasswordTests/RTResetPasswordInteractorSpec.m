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

    __block NSString *resetCode = @"reset";
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
                                                                  withCallback:[callbackCaptor capture]];
            
            [verifyCount(delegate, never()) resetPasswordEmailSent];
            
            void (^callback)() = [callbackCaptor value];
            callback();
            
            [verify(delegate) resetPasswordEmailSent];
        });
    });
    
    describe(@"reset password", ^{
        
        context(@"registered client", ^{
            void (^givenValid)(BOOL) = ^(BOOL valid) {
                [[given([validator validateCode:resetCode username:username newPassword:password errors:nil]) withMatcher:anything() forArgument:3]
                 willReturnBool:valid];
            };
            
            void (^givenClientCredentials)(RTClientCredentials *) = ^(RTClientCredentials *credentials) {
                [given([currentUserService clientCredentialsForCurrentUser]) willReturn:credentials];
            };
        
            it(@"validation errors", ^{
                givenValid(NO);
                [interactor resetPasswordForCurrentClientWithCode:resetCode username:username newPassword:password];
                [verify(delegate) resetPasswordFailedWithErrors:anything()];
            });
            
            it(@"unknown client", ^{
                givenValid(YES);
                givenClientCredentials(nil);
                
                [interactor resetPasswordForCurrentClientWithCode:resetCode username:username newPassword:password];
                expectResetError(RTResetPasswordErrorUnknownClient);
            });
            
            it(@"successful reset", ^{
                givenValid(YES);
                givenClientCredentials(clientCredentials);
                
                [interactor resetPasswordForCurrentClientWithCode:resetCode username:username newPassword:password];
                
                [verify(dataManager) resetPasswordToNewPassword:password
                                                    forUsername:username
                                              clientCredentials:clientCredentials
                                                       withCode:resetCode
                                                       callback:[callbackCaptor capture]];

                void (^callback)() = [callbackCaptor value];
                callback();
                
                [verify(delegate) resetPasswordSucceeded];
            });
        });
        
        context(@"new client", ^{
            
        });
    });
    
    describe(@"data manager delegate", ^{
        it(@"should forward email errors to delegate", ^{
            NSError *error = [RTErrorFactory resetPasswordErrorWithCode:RTResetPasswordErrorInvalidResetCode];
            [interactor submitRequestForResetPasswordEmailFailedWithErrors:@[error]];
            expectEmailError(RTResetPasswordErrorInvalidResetCode);
        });
    });
});

SpecEnd