#import "RTTestCommon.h"

#import "RTChangePasswordInteractor.h"
#import "RTChangePasswordInteractorDelegate.h"
#import "RTChangePasswordDataManager.h"

#import "RTChangePasswordError.h"
#import "RTErrorFactory.h"


SpecBegin(RTChangePasswordInteractor)

describe(@"change password interactor", ^{
    
    __block RTChangePasswordInteractor *interactor;

    __block id<RTChangePasswordInteractorDelegate> delegate;
    __block RTChangePasswordDataManager *dataManager;
    
    __block MKTArgumentCaptor *changedCaptor;
    __block MKTArgumentCaptor *notChangedCaptor;
    
    beforeEach(^{
        dataManager = mock([RTChangePasswordDataManager class]);
        delegate = mockProtocol(@protocol(RTChangePasswordInteractorDelegate));
        
        interactor = [[RTChangePasswordInteractor alloc] initWithDelegate:delegate
                                                              dataManager:dataManager];
        
        changedCaptor = [[MKTArgumentCaptor alloc] init];
        notChangedCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"change password", ^{
        context(@"valid parameters", ^{
            beforeEach(^{
                [interactor changePassword:password confirmationPassword:password];
                [verify(dataManager) changePassword:password
                                            changed:[changedCaptor capture]
                                         notChanged:[notChangedCaptor capture]];
            });
            
            it(@"should notify delegate of success", ^{
                NoArgsCallback callback = [changedCaptor value];
                callback();
                [verify(delegate) changePasswordSucceeded];
            });
        });
        
        context(@"missing or invalid parameters", ^{
            __block RTValidationTestHelper *helper;
            
            ValidationCallback validationCallback = ^BOOL (NSDictionary *parameters, NSArray *__autoreleasing *errors) {
                NSString *passwordParam = parameters[PASSWORD_KEY];
                NSString *confirmationParam = parameters[CONFIRMATION_PASSWORD_KEY];

                [interactor changePassword:getParameterOrDefault(passwordParam, password)
                      confirmationPassword:getParameterOrDefault(confirmationParam, password)];

                MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
                [verify(delegate) changePasswordFailedWithErrors:[errorCaptor capture]];
                
                [verify(delegate) reset];
                
                NSArray *capturedErrors = [errorCaptor value];
                *errors = capturedErrors;
                
                return NO;
            };
            
            ErrorFactoryCallback errorFactoryCallback = ^NSError * (NSInteger errorCode) {
                return [RTErrorFactory changePasswordErrorWithCode:errorCode];
            };
            
            beforeEach(^{
                helper = [[RTValidationTestHelper alloc] initWithValidationCallback:validationCallback
                                                               errorFactoryCallback:errorFactoryCallback];
            });
            
            it(@"blank password", ^{
                [helper expectErrorCodes:@[@(RTChangePasswordErrorMissingPassword)] forParameters:@{PASSWORD_KEY: BLANK}];
                [helper expectErrorCodes:@[@(RTChangePasswordErrorMissingPassword)] forParameters:@{PASSWORD_KEY: null()}];
            });
            
            it(@"blank confirmation password", ^{
                [helper expectErrorCodes:@[@(RTChangePasswordErrorMissingConfirmationPassword)] forParameters:@{CONFIRMATION_PASSWORD_KEY: BLANK}];
                [helper expectErrorCodes:@[@(RTChangePasswordErrorMissingConfirmationPassword)] forParameters:@{CONFIRMATION_PASSWORD_KEY: null()}];
            });
            
            it(@"all blank", ^{
                NSDictionary *parameters = @{
                                             PASSWORD_KEY: BLANK,
                                             CONFIRMATION_PASSWORD_KEY: BLANK
                                             };
                
                NSArray *expectedErrorCodes = @[
                                                @(RTChangePasswordErrorMissingPassword),
                                                @(RTChangePasswordErrorMissingConfirmationPassword)
                                                ];
                
                [helper expectErrorCodes:expectedErrorCodes forParameters:parameters];
            });
            
            it(@"password matches confirmation password but is too short", ^{
                [helper expectErrorCodes:@[@(RTChangePasswordErrorInvalidPassword)] forParameters:@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: @"a"}];
                [helper expectErrorCodes:@[@(RTChangePasswordErrorInvalidPassword)] forParameters:@{PASSWORD_KEY: @"abcde", CONFIRMATION_PASSWORD_KEY: @"abcde"}];
            });
            
            // TODO: Explore this more
            xit(@"password does not count control characters", ^{
                [helper expectErrorCodes:@[@(RTChangePasswordErrorInvalidPassword)] forParameters:@{PASSWORD_KEY: @"abcd\n"}];
                [helper expectErrorCodes:@[@(RTChangePasswordErrorInvalidPassword)] forParameters:@{PASSWORD_KEY: @"abcde\n"}];
            });
            
            it(@"password does not match confirmation password", ^{
                [helper expectErrorCodes:@[@(RTChangePasswordErrorMissingPassword), @(RTChangePasswordErrorMissingConfirmationPassword)]
                           forParameters:@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: BLANK}];
                
                [helper expectErrorCodes:@[@(RTChangePasswordErrorMissingPassword)]
                           forParameters:@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"a"}];
                
                [helper expectErrorCodes:@[@(RTChangePasswordErrorInvalidPassword), @(RTAccountRegistrationErrorMissingConfirmationPassword)]
                           forParameters:@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: BLANK}];
                
                [helper expectErrorCodes:@[@(RTChangePasswordErrorMissingConfirmationPassword)]
                           forParameters:@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: BLANK}];
                
                [helper expectErrorCodes:@[@(RTChangePasswordErrorMissingPassword)]
                           forParameters:@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"abcdef"}];
                
                [helper expectErrorCodes:@[@(RTChangePasswordErrorConfirmationPasswordDoesNotMatch)]
                           forParameters:@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: @"ABCDEF"}];
            });
        });
    });
});

SpecEnd
