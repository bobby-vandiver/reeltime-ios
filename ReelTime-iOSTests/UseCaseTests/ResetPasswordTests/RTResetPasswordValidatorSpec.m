#import "RTTestCommon.h"

#import "RTResetPasswordValidator.h"
#import "RTResetPasswordError.h"

#import "RTErrorFactory.h"

SpecBegin(RTResetPasswordValidator)

describe(@"reset password validator", ^{
    __block RTResetPasswordValidator *validator;

    // TODO: Move this to test common and update other tests
    NSString *const resetCode = @"reset";
    
    NSString *const CODE_KEY = @"code";
    NSString *const USERNAME_KEY = @"username";
    NSString *const PASSWORD_KEY = @"password";
    NSString *const CONFIRMATION_PASSWORD_KEY = @"confirmationPassword";
    NSString *const CLIENT_NAME_KEY = @"clientName";

    void (^expectErrors)(NSArray *errors, NSArray *expectedErrorCodes) = ^(NSArray *errors, NSArray *expectedErrorCodes) {
        expect(errors).to.haveACountOf(expectedErrorCodes.count);
        
        for (NSNumber *errorCode in expectedErrorCodes) {
            NSError *expected = [RTErrorFactory resetPasswordErrorWithCode:[errorCode integerValue]];
            expect(errors).to.contain(expected);
        }
    };
    
    beforeEach(^{
        validator = [[RTResetPasswordValidator alloc] init];
    });
    
    context(@"registered client", ^{
        void (^expectErrorsForBadParametersForRegisteredClient)(NSDictionary *parameters, NSArray *expectedErrorCodes) =
        ^(NSDictionary *parameters, NSArray *expectedErrorCodes) {
            
            NSString *codeParam = parameters[CODE_KEY];
            NSString *usernameParam = parameters[USERNAME_KEY];
            NSString *passwordParam = parameters[PASSWORD_KEY];
            NSString *confirmationPasswordParam = parameters[CONFIRMATION_PASSWORD_KEY];
            
            NSArray *errors;
            BOOL valid = [validator validateCode:getParameterOrDefault(codeParam, resetCode)
                                        username:getParameterOrDefault(usernameParam, username)
                                        password:getParameterOrDefault(passwordParam, password)
                            confirmationPassword:getParameterOrDefault(confirmationPasswordParam, password)
                                          errors:&errors];
            
            expect(valid).to.beFalsy();
            expectErrors(errors, expectedErrorCodes);
        };
        
        context(@"missing parameters", ^{
            it(@"blank code", ^{
                expectErrorsForBadParametersForRegisteredClient(@{CODE_KEY: BLANK}, @[@(RTResetPasswordErrorMissingResetCode)]);
                expectErrorsForBadParametersForRegisteredClient(@{CODE_KEY: [NSNull null]}, @[@(RTResetPasswordErrorMissingResetCode)]);
            });
            
            it(@"blank username", ^{
                expectErrorsForBadParametersForRegisteredClient(@{USERNAME_KEY: BLANK}, @[@(RTResetPasswordErrorMissingUsername)]);
                expectErrorsForBadParametersForRegisteredClient(@{USERNAME_KEY: [NSNull null]}, @[@(RTResetPasswordErrorMissingUsername)]);
            });
            
            it(@"blank password", ^{
                expectErrorsForBadParametersForRegisteredClient(@{PASSWORD_KEY: BLANK}, @[@(RTResetPasswordErrorMissingPassword)]);
                expectErrorsForBadParametersForRegisteredClient(@{PASSWORD_KEY: [NSNull null]}, @[@(RTResetPasswordErrorMissingPassword)]);
            });
            
            it(@"blank confirmation password", ^{
                expectErrorsForBadParametersForRegisteredClient(@{CONFIRMATION_PASSWORD_KEY: BLANK}, @[@(RTResetPasswordErrorMissingConfirmationPassword)]);
                
                expectErrorsForBadParametersForRegisteredClient(@{CONFIRMATION_PASSWORD_KEY: [NSNull null]}, @[@(RTResetPasswordErrorMissingConfirmationPassword)]);
            });
            
            it(@"all blank", ^{
                NSDictionary *parameters = @{
                                             CODE_KEY: BLANK,
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
                
                expectErrorsForBadParametersForRegisteredClient(parameters, expectedErrorCodes);
            });
        });
        
        context(@"invalid parameters", ^{
            
            describe(@"invalid password", ^{
                it(@"matches confirmation password but is too short", ^{
                    expectErrorsForBadParametersForRegisteredClient(@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: @"a"},
                                                                    @[@(RTResetPasswordErrorInvalidPassword)]);
                    
                    expectErrorsForBadParametersForRegisteredClient(@{PASSWORD_KEY: @"abcde", CONFIRMATION_PASSWORD_KEY: @"abcde"},
                                                                    @[@(RTResetPasswordErrorInvalidPassword)]);
                });
                
                it(@"does not match confirmation password", ^{
                    expectErrorsForBadParametersForRegisteredClient(@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: BLANK},
                                                                    @[@(RTResetPasswordErrorMissingPassword),
                                                                      @(RTResetPasswordErrorMissingConfirmationPassword)]);
                    
                    expectErrorsForBadParametersForRegisteredClient(@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"a"},
                                                                    @[@(RTResetPasswordErrorMissingPassword)]);
                    
                    expectErrorsForBadParametersForRegisteredClient(@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: BLANK},
                                                                    @[@(RTResetPasswordErrorInvalidPassword),
                                                                      @(RTResetPasswordErrorMissingConfirmationPassword)]);
                    
                    expectErrorsForBadParametersForRegisteredClient(@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: BLANK},
                                                                    @[@(RTResetPasswordErrorMissingConfirmationPassword)]);
                    
                    expectErrorsForBadParametersForRegisteredClient(@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"abcdef"},
                                                                    @[@(RTResetPasswordErrorMissingPassword)]);
                    
                    expectErrorsForBadParametersForRegisteredClient(@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: @"ABCDEF"},
                                                                    @[@(RTResetPasswordErrorConfirmationPasswordDoesNotMatch)]);
                });
            });
        });
    });
    
    context(@"new client", ^{
        void (^expectErrorsForBadParametersForNewClient)(NSDictionary *parameters, NSArray *expectedErrorCodes) =
        ^(NSDictionary *parameters, NSArray *expectedErrorCodes) {
            
            NSString *codeParam = parameters[CODE_KEY];
            NSString *usernameParam = parameters[USERNAME_KEY];
            NSString *passwordParam = parameters[PASSWORD_KEY];
            NSString *confirmationPasswordParam = parameters[CONFIRMATION_PASSWORD_KEY];
            NSString *clientNameParam = parameters[CLIENT_NAME_KEY];
 
            NSArray *errors;
            BOOL valid = [validator validateCode:getParameterOrDefault(codeParam, resetCode)
                                        username:getParameterOrDefault(usernameParam, username)
                                        password:getParameterOrDefault(passwordParam, password)
                            confirmationPassword:getParameterOrDefault(confirmationPasswordParam, password)
                                      clientName:getParameterOrDefault(clientNameParam, clientName)
                                          errors:&errors];
            
            expect(valid).to.beFalsy();
            expectErrors(errors, expectedErrorCodes);
        };

        context(@"missing parameters", ^{
            it(@"blank code", ^{
                expectErrorsForBadParametersForNewClient(@{CODE_KEY: BLANK}, @[@(RTResetPasswordErrorMissingResetCode)]);
                expectErrorsForBadParametersForNewClient(@{CODE_KEY: [NSNull null]}, @[@(RTResetPasswordErrorMissingResetCode)]);
            });
            
            it(@"blank username", ^{
                expectErrorsForBadParametersForNewClient(@{USERNAME_KEY: BLANK}, @[@(RTResetPasswordErrorMissingUsername)]);
                expectErrorsForBadParametersForNewClient(@{USERNAME_KEY: [NSNull null]}, @[@(RTResetPasswordErrorMissingUsername)]);
            });
            
            it(@"blank password", ^{
                expectErrorsForBadParametersForNewClient(@{PASSWORD_KEY: BLANK}, @[@(RTResetPasswordErrorMissingPassword)]);
                expectErrorsForBadParametersForNewClient(@{PASSWORD_KEY: [NSNull null]}, @[@(RTResetPasswordErrorMissingPassword)]);
            });
            
            it(@"blank confirmation password", ^{
                expectErrorsForBadParametersForNewClient(@{CONFIRMATION_PASSWORD_KEY: BLANK}, @[@(RTResetPasswordErrorMissingConfirmationPassword)]);
                
                expectErrorsForBadParametersForNewClient(@{CONFIRMATION_PASSWORD_KEY: [NSNull null]}, @[@(RTResetPasswordErrorMissingConfirmationPassword)]);
            });
            
            it(@"blank client name", ^{
                expectErrorsForBadParametersForNewClient(@{CLIENT_NAME_KEY: BLANK}, @[@(RTResetPasswordErrorMissingClientName)]);
                expectErrorsForBadParametersForNewClient(@{CLIENT_NAME_KEY: [NSNull null]}, @[@(RTResetPasswordErrorMissingClientName)]);
            });
            
            it(@"all blank", ^{
                NSDictionary *parameters = @{
                                             CODE_KEY: BLANK,
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
                
                expectErrorsForBadParametersForNewClient(parameters, expectedErrorCodes);
            });
        });
        
        context(@"invalid parameters", ^{
            
            describe(@"invalid password", ^{
                it(@"matches confirmation password but is too short", ^{
                    expectErrorsForBadParametersForNewClient(@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: @"a"},
                                                             @[@(RTResetPasswordErrorInvalidPassword)]);
                    
                    expectErrorsForBadParametersForNewClient(@{PASSWORD_KEY: @"abcde", CONFIRMATION_PASSWORD_KEY: @"abcde"},
                                                             @[@(RTResetPasswordErrorInvalidPassword)]);
                });
                
                it(@"does not match confirmation password", ^{
                    expectErrorsForBadParametersForNewClient(@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: BLANK},
                                                             @[@(RTResetPasswordErrorMissingPassword),
                                                               @(RTResetPasswordErrorMissingConfirmationPassword)]);
                    
                    expectErrorsForBadParametersForNewClient(@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"a"},
                                                             @[@(RTResetPasswordErrorMissingPassword)]);
                    
                    expectErrorsForBadParametersForNewClient(@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: BLANK},
                                                             @[@(RTResetPasswordErrorInvalidPassword),
                                                               @(RTResetPasswordErrorMissingConfirmationPassword)]);
                    
                    expectErrorsForBadParametersForNewClient(@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: BLANK},
                                                             @[@(RTResetPasswordErrorMissingConfirmationPassword)]);
                    
                    expectErrorsForBadParametersForNewClient(@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"abcdef"},
                                                             @[@(RTResetPasswordErrorMissingPassword)]);
                    
                    expectErrorsForBadParametersForNewClient(@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: @"ABCDEF"},
                                                             @[@(RTResetPasswordErrorConfirmationPasswordDoesNotMatch)]);
                });
            });
        });
    });
});

SpecEnd