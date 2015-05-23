#import "RTTestCommon.h"

#import "RTResetPasswordValidator.h"
#import "RTResetPasswordError.h"

#import "RTErrorFactory.h"

SpecBegin(RTResetPasswordValidator)

describe(@"reset password validator", ^{

    __block RTResetPasswordValidator *validator;
    __block RTValidationTestHelper *helper;
   
    ErrorFactoryCallback errorFactoryCallback = ^NSError * (NSInteger errorCode) {
        return [RTErrorFactory resetPasswordErrorWithCode:errorCode];
    };
    
    beforeEach(^{
        validator = [[RTResetPasswordValidator alloc] init];
    });
    
    context(@"registered client", ^{

        ValidationCallback validationCallback = ^BOOL (NSDictionary *parameters, NSArray *__autoreleasing *errors) {
            NSString *codeParam = parameters[RESET_CODE_KEY];
            NSString *usernameParam = parameters[USERNAME_KEY];
            NSString *passwordParam = parameters[PASSWORD_KEY];
            NSString *confirmationPasswordParam = parameters[CONFIRMATION_PASSWORD_KEY];
            
            BOOL valid = [validator validateCode:getParameterOrDefault(codeParam, resetCode)
                                        username:getParameterOrDefault(usernameParam, username)
                                        password:getParameterOrDefault(passwordParam, password)
                            confirmationPassword:getParameterOrDefault(confirmationPasswordParam, password)
                                          errors:errors];
            
            return valid;
        };
        
        beforeEach(^{
            helper = [[RTValidationTestHelper alloc] initWithValidationCallback:validationCallback
                                                           errorFactoryCallback:errorFactoryCallback];
        });
        
        context(@"missing parameters", ^{
            it(@"blank code", ^{
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingResetCode)] forParameters:@{RESET_CODE_KEY: BLANK}];
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingResetCode)] forParameters:@{RESET_CODE_KEY: null()}];
            });
            
            it(@"blank username", ^{
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingUsername)] forParameters:@{USERNAME_KEY: BLANK}];
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingUsername)] forParameters:@{USERNAME_KEY: null()}];
            });
            
            it(@"blank password", ^{
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingPassword)] forParameters:@{PASSWORD_KEY: BLANK}];
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingPassword)] forParameters:@{PASSWORD_KEY: null()}];
            });
            
            it(@"blank confirmation password", ^{
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingConfirmationPassword)] forParameters:@{CONFIRMATION_PASSWORD_KEY: BLANK}];
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingConfirmationPassword)] forParameters:@{CONFIRMATION_PASSWORD_KEY: null()}];
            });
            
            it(@"all blank", ^{
                NSDictionary *parameters = @{
                                             RESET_CODE_KEY: BLANK,
                                             USERNAME_KEY: BLANK,
                                             PASSWORD_KEY: BLANK,
                                             CONFIRMATION_PASSWORD_KEY: BLANK
                                             };
                
                NSArray *expectedErrorCodes = @[
                                                @(RTResetPasswordErrorMissingResetCode),
                                                @(RTResetPasswordErrorMissingUsername),
                                                @(RTResetPasswordErrorMissingPassword),
                                                @(RTResetPasswordErrorMissingConfirmationPassword)
                                                ];
                
                [helper expectErrorCodes:expectedErrorCodes forParameters:parameters];
            });
        });
        
        context(@"invalid parameters", ^{
            
            describe(@"invalid password", ^{
                it(@"matches confirmation password but is too short", ^{
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorInvalidPassword)] forParameters:@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: @"a"}];
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorInvalidPassword)] forParameters:@{PASSWORD_KEY: @"abcde", CONFIRMATION_PASSWORD_KEY: @"abcde"}];
                });
                
                it(@"does not match confirmation password", ^{
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingPassword), @(RTResetPasswordErrorMissingConfirmationPassword)]
                               forParameters:@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: BLANK}];
                    
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingPassword)]
                               forParameters:@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"a"}];
                    
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorInvalidPassword), @(RTResetPasswordErrorMissingConfirmationPassword)]
                               forParameters:@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: BLANK}];
                    
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingConfirmationPassword)]
                               forParameters:@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: BLANK}];
                    
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingPassword)]
                               forParameters:@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"abcdef"}];
                    
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorConfirmationPasswordDoesNotMatch)]
                               forParameters:@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: @"ABCDEF"}];
                });
            });
        });
    });
    
    context(@"new client", ^{
        
        ValidationCallback validationCallback = ^BOOL (NSDictionary *parameters, NSArray *__autoreleasing *errors) {
            NSString *codeParam = parameters[RESET_CODE_KEY];
            NSString *usernameParam = parameters[USERNAME_KEY];
            NSString *passwordParam = parameters[PASSWORD_KEY];
            NSString *confirmationPasswordParam = parameters[CONFIRMATION_PASSWORD_KEY];
            NSString *clientNameParam = parameters[CLIENT_NAME_KEY];
            
            BOOL valid = [validator validateCode:getParameterOrDefault(codeParam, resetCode)
                                        username:getParameterOrDefault(usernameParam, username)
                                        password:getParameterOrDefault(passwordParam, password)
                            confirmationPassword:getParameterOrDefault(confirmationPasswordParam, password)
                                      clientName:getParameterOrDefault(clientNameParam, clientName)
                                          errors:errors];
            return valid;
        };

        beforeEach(^{
            helper = [[RTValidationTestHelper alloc] initWithValidationCallback:validationCallback
                                                           errorFactoryCallback:errorFactoryCallback];
        });
        
        context(@"missing parameters", ^{
            it(@"blank code", ^{
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingResetCode)] forParameters:@{RESET_CODE_KEY: BLANK}];
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingResetCode)] forParameters:@{RESET_CODE_KEY: null()}];
            });
            
            it(@"blank username", ^{
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingUsername)] forParameters:@{USERNAME_KEY: BLANK}];
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingUsername)] forParameters:@{USERNAME_KEY: null()}];
            });
            
            it(@"blank password", ^{
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingPassword)] forParameters:@{PASSWORD_KEY: BLANK}];
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingPassword)] forParameters:@{PASSWORD_KEY: null()}];
            });
            
            it(@"blank confirmation password", ^{
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingConfirmationPassword)] forParameters:@{CONFIRMATION_PASSWORD_KEY: BLANK}];
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingConfirmationPassword)] forParameters:@{CONFIRMATION_PASSWORD_KEY: null()}];
            });
            
            it(@"blank client name", ^{
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingClientName)] forParameters:@{CLIENT_NAME_KEY: BLANK}];
                [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingClientName)] forParameters:@{CLIENT_NAME_KEY: null()}];
            });
            
            it(@"all blank", ^{
                NSDictionary *parameters = @{
                                             RESET_CODE_KEY: BLANK,
                                             USERNAME_KEY: BLANK,
                                             PASSWORD_KEY: BLANK,
                                             CONFIRMATION_PASSWORD_KEY: BLANK,
                                             CLIENT_NAME_KEY: BLANK
                                             };
                
                NSArray *expectedErrorCodes = @[
                                                @(RTResetPasswordErrorMissingResetCode),
                                                @(RTResetPasswordErrorMissingUsername),
                                                @(RTResetPasswordErrorMissingPassword),
                                                @(RTResetPasswordErrorMissingConfirmationPassword),
                                                @(RTResetPasswordErrorMissingClientName)
                                                ];
                
                [helper expectErrorCodes:expectedErrorCodes forParameters:parameters];
            });
        });
        
        context(@"invalid parameters", ^{
            
            describe(@"invalid password", ^{
                it(@"matches confirmation password but is too short", ^{
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorInvalidPassword)] forParameters:@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: @"a"}];
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorInvalidPassword)] forParameters:@{PASSWORD_KEY: @"abcde", CONFIRMATION_PASSWORD_KEY: @"abcde"}];
                });
                
                it(@"does not match confirmation password", ^{
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingPassword), @(RTResetPasswordErrorMissingConfirmationPassword)]
                               forParameters:@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: BLANK}];
                    
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingPassword)]
                               forParameters:@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"a"}];
                    
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorInvalidPassword), @(RTResetPasswordErrorMissingConfirmationPassword)]
                               forParameters:@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: BLANK}];
                    
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingConfirmationPassword)]
                               forParameters:@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: BLANK}];
                    
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorMissingPassword)]
                               forParameters:@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"abcdef"}];
                    
                    [helper expectErrorCodes:@[@(RTResetPasswordErrorConfirmationPasswordDoesNotMatch)]
                               forParameters:@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: @"ABCDEF"}];
                });
            });
        });
    });
});

SpecEnd