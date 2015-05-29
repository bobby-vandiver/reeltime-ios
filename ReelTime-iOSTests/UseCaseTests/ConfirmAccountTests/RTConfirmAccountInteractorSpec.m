#import "RTTestCommon.h"

#import "RTConfirmAccountInteractor.h"
#import "RTConfirmAccountInteractorDelegate.h"
#import "RTConfirmAccountDataManager.h"

#import "RTConfirmAccountError.h"
#import "RTErrorFactory.h"

SpecBegin(RTConfirmAccountInteractor)

describe(@"confirm account interactor", ^{
    
    __block RTConfirmAccountInteractor *interactor;
    
    __block id<RTConfirmAccountInteractorDelegate> delegate;
    __block RTConfirmAccountDataManager *dataManager;
    
    beforeEach(^{
        dataManager = mock([RTConfirmAccountDataManager class]);
        delegate = mockProtocol(@protocol(RTConfirmAccountInteractorDelegate));
        
        interactor = [[RTConfirmAccountInteractor alloc] initWithDelegate:delegate
                                                              dataManager:dataManager];
    });
    
    describe(@"send confirmation email", ^{
        __block MKTArgumentCaptor *emailSentCaptor;
        __block MKTArgumentCaptor *emailFailedCaptor;
        
        beforeEach(^{
            emailSentCaptor = [[MKTArgumentCaptor alloc] init];
            emailFailedCaptor = [[MKTArgumentCaptor alloc] init];
            
            [interactor sendConfirmationEmail];
            [verify(dataManager) submitRequestForConfirmationEmailWithEmailSent:[emailSentCaptor capture]
                                                                    emailFailed:[emailFailedCaptor capture]];
        });
        
        it(@"should notify delegate of success", ^{
            NoArgsCallback callback = [emailSentCaptor value];
            callback();
            [verify(delegate) confirmationEmailSent];
        });
        
        it(@"should forward email errors to delegate", ^{
            ArrayCallback callback = [emailFailedCaptor value];
            
            NSError *error = [RTErrorFactory confirmAccountErrorWithCode:RTConfirmAccountErrorEmailFailure];
            callback(@[error]);
            
            MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
            [verify(delegate) confirmationEmailFailedWithErrors:[captor capture]];
            
            NSArray *captured = [captor value];
            expect(captured).to.haveACountOf(1);
            expect(captured).to.contain(error);
        });
    });
    
    describe(@"confirm account", ^{
        __block MKTArgumentCaptor *confirmationSuccessCaptor;
        __block MKTArgumentCaptor *confirmationFailureCaptor;
        
        context(@"valid parameters", ^{
            beforeEach(^{
                confirmationSuccessCaptor = [[MKTArgumentCaptor alloc] init];
                confirmationFailureCaptor = [[MKTArgumentCaptor alloc] init];
                
                [interactor confirmAccountWithCode:confirmationCode];
                [verify(dataManager) confirmAccountWithCode:confirmationCode
                                        confirmationSuccess:[confirmationSuccessCaptor capture]
                                                    failure:[confirmationFailureCaptor capture]];
            });
            
            it(@"should notify delegate of success", ^{
                NoArgsCallback callback = [confirmationSuccessCaptor value];
                callback();
                [verify(delegate) confirmAccountSucceeded];
            });
            
            it(@"should notify delegate of failure", ^{
                ArrayCallback callback = [confirmationFailureCaptor value];
                
                NSError *error = [RTErrorFactory confirmAccountErrorWithCode:RTConfirmAccountErrorInvalidConfirmationCode];
                callback(@[error]);
                
                MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
                [verify(delegate) confirmAccountFailedWithErrors:[captor capture]];
                
                NSArray *captured = [captor value];
                expect(captured).to.haveACountOf(1);
                expect(captured).to.contain(error);
            });
        });
        
        context(@"missing parameters", ^{
            __block RTValidationTestHelper *helper;
            
            ValidationCallback validationCallback = ^BOOL (NSDictionary *parameters, NSArray *__autoreleasing *errors) {
                NSString *confirmationCodeParam = parameters[CONFIRMATION_CODE_KEY];
                
                [interactor confirmAccountWithCode:getParameterOrDefault(confirmationCodeParam, confirmationCode)];
                
                MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
                [verify(delegate) confirmAccountFailedWithErrors:[errorCaptor capture]];
                
                [verify(delegate) reset];
                
                NSArray *capturedErrors = [errorCaptor value];
                *errors = capturedErrors;
                
                return NO;
            };
            
            ErrorFactoryCallback errorFactoryCallback = ^NSError * (NSInteger errorCode) {
                return [RTErrorFactory confirmAccountErrorWithCode:errorCode];
            };
            
            beforeEach(^{
                helper = [[RTValidationTestHelper alloc] initWithValidationCallback:validationCallback
                                                               errorFactoryCallback:errorFactoryCallback];
            });
            
            it(@"blank code", ^{
                [helper expectErrorCodes:@[@(RTConfirmAccountErrorMissingConfirmationCode)]
                           forParameters:@{CONFIRMATION_CODE_KEY: BLANK}];
                
                [helper expectErrorCodes:@[@(RTConfirmAccountErrorMissingConfirmationCode)]
                           forParameters:@{CONFIRMATION_CODE_KEY: null()}];
            });
        });
    });
});

SpecEnd
