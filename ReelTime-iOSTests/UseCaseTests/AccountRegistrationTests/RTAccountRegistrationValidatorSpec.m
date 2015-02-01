#import "RTTestCommon.h"

#import "RTAccountRegistration.h"
#import "RTAccountRegistrationValidator.h"
#import "RTAccountRegistrationError.h"
#import "RTErrorFactory.h"

SpecBegin(RTAccountRegistrationValidator)

describe(@"account registration validator", ^{
    __block RTAccountRegistrationValidator *validator;
    
    NSString *const USERNAME_KEY = @"username";
    NSString *const PASSWORD_KEY = @"password";
    NSString *const CONFIRMATION_PASSWORD_KEY = @"confirmationPassword";
    NSString *const EMAIL_KEY = @"email";
    NSString *const DISPLAY_NAME_KEY = @"displayName";
    NSString *const CLIENT_NAME_KEY = @"clientName";

    NSString *(^getParameterOrDefault)(NSString *parameter, NSString *defaultValue) =
    ^NSString *(NSString *parameter, NSString *defaultValue) {
        NSString *value;

        if (parameter) {
            value = [parameter isEqual:[NSNull null]] ? nil : parameter;
        }
        else {
            value = defaultValue;
        }
        
        return value;
    };
    
    void (^expectErrorForBadParameters)(NSDictionary *parameters, NSArray *expectedErrorCodes) =
    ^(NSDictionary *parameters, NSArray *expectedErrorCodes) {
        
        NSString *usernameParam = [parameters objectForKey:USERNAME_KEY];
        NSString *passwordParam = [parameters objectForKey:PASSWORD_KEY];
        NSString *confirmationParam = [parameters objectForKey:CONFIRMATION_PASSWORD_KEY];
        NSString *emailParam = [parameters objectForKey:EMAIL_KEY];
        NSString *displayNameParam = [parameters objectForKey:DISPLAY_NAME_KEY];
        NSString *clientNameParam = [parameters objectForKey:CLIENT_NAME_KEY];
        
        RTAccountRegistration *registration = [RTAccountRegistration alloc];
        registration = [registration initWithUsername:getParameterOrDefault(usernameParam, username)
                                             password:getParameterOrDefault(passwordParam, password)
                                 confirmationPassword:getParameterOrDefault(confirmationParam, password)
                                                email:getParameterOrDefault(emailParam, email)
                                          displayName:getParameterOrDefault(displayNameParam, displayName)
                                           clientName:getParameterOrDefault(clientNameParam, clientName)];
        
        NSArray *errors;
        BOOL valid = [validator validateAccountRegistration:registration errors:&errors];

        expect(valid).to.beFalsy();
        expect([errors count]).to.equal([expectedErrorCodes count]);
        
        for (NSNumber *errorCode in expectedErrorCodes) {
            NSError *expected = [RTErrorFactory accountRegistrationErrorWithCode:[errorCode integerValue]];
            expect(errors).to.contain(expected);
        }
    };

    beforeEach(^{
        validator = [[RTAccountRegistrationValidator alloc] init];
    });

    context(@"missing parameters", ^{
        it(@"blank username", ^{
            expectErrorForBadParameters(@{USERNAME_KEY: BLANK}, @[@(RTAccountRegistrationErrorMissingUsername)]);
            expectErrorForBadParameters(@{USERNAME_KEY: [NSNull null]}, @[@(RTAccountRegistrationErrorMissingUsername)]);
        });
        
        it(@"blank password", ^{
            expectErrorForBadParameters(@{PASSWORD_KEY: BLANK}, @[@(RTAccountRegistrationErrorMissingPassword)]);
            expectErrorForBadParameters(@{PASSWORD_KEY: [NSNull null]}, @[@(RTAccountRegistrationErrorMissingPassword)]);
        });
        
        it(@"blank confirmation password", ^{
            expectErrorForBadParameters(@{CONFIRMATION_PASSWORD_KEY: BLANK}, @[@(RTAccountRegistrationErrorMissingConfirmationPassword)]);
            expectErrorForBadParameters(@{CONFIRMATION_PASSWORD_KEY: [NSNull null]},
                                        @[@(RTAccountRegistrationErrorMissingConfirmationPassword)]);
        });
        
        it(@"blank email", ^{
            expectErrorForBadParameters(@{EMAIL_KEY: BLANK}, @[@(RTAccountRegistrationErrorMissingEmail)]);
            expectErrorForBadParameters(@{EMAIL_KEY: [NSNull null]}, @[@(RTAccountRegistrationErrorMissingEmail)]);
        });
        
        it(@"blank display name", ^{
            expectErrorForBadParameters(@{DISPLAY_NAME_KEY: BLANK}, @[@(RTAccountRegistrationErrorMissingDisplayName)]);
            expectErrorForBadParameters(@{DISPLAY_NAME_KEY: [NSNull null]}, @[@(RTAccountRegistrationErrorMissingDisplayName)]);
        });
        
        it(@"blank client name", ^{
            expectErrorForBadParameters(@{CLIENT_NAME_KEY: BLANK}, @[@(RTAccountRegistrationErrorMissingClientName)]);
            expectErrorForBadParameters(@{CLIENT_NAME_KEY: [NSNull null]}, @[@(RTAccountRegistrationErrorMissingClientName)]);
        });
        
        it(@"all blank", ^{
            NSDictionary *parameters = @{
                                         USERNAME_KEY: BLANK,
                                         PASSWORD_KEY: BLANK,
                                         CONFIRMATION_PASSWORD_KEY: BLANK,
                                         EMAIL_KEY: BLANK,
                                         DISPLAY_NAME_KEY: BLANK,
                                         CLIENT_NAME_KEY: BLANK
                                         };
            
            NSArray *expectedErrorCodes = @[
                                            @(RTAccountRegistrationErrorMissingUsername),
                                            @(RTAccountRegistrationErrorMissingPassword),
                                            @(RTAccountRegistrationErrorMissingConfirmationPassword),
                                            @(RTAccountRegistrationErrorMissingEmail),
                                            @(RTAccountRegistrationErrorMissingDisplayName),
                                            @(RTAccountRegistrationErrorMissingClientName)
                                            ];
            
            expectErrorForBadParameters(parameters, expectedErrorCodes);
        });
    });
    
    context(@"invalid parameters", ^{
        
        describe(@"invalid username", ^{
            it(@"too short", ^{
                expectErrorForBadParameters(@{USERNAME_KEY: @"a"}, @[@(RTAccountRegistrationErrorInvalidUsername)]);
            });
            
            it(@"too long", ^{
                expectErrorForBadParameters(@{USERNAME_KEY: @"abcdefghijklmnop"}, @[@(RTAccountRegistrationErrorInvalidUsername)]);
                expectErrorForBadParameters(@{USERNAME_KEY: @"aBcdEFghIjklmnop1234"}, @[@(RTAccountRegistrationErrorInvalidUsername)]);
            });
            
            it(@"cannot contain space", ^{
                expectErrorForBadParameters(@{USERNAME_KEY: @"a b"}, @[@(RTAccountRegistrationErrorInvalidUsername)]);
                expectErrorForBadParameters(@{USERNAME_KEY: @" ab"}, @[@(RTAccountRegistrationErrorInvalidUsername)]);
                expectErrorForBadParameters(@{USERNAME_KEY: @"ab "}, @[@(RTAccountRegistrationErrorInvalidUsername)]);
            });
            
            it(@"invalid characters", ^{
                expectErrorForBadParameters(@{USERNAME_KEY: @"!ab"}, @[@(RTAccountRegistrationErrorInvalidUsername)]);
                expectErrorForBadParameters(@{USERNAME_KEY: @"a!b"}, @[@(RTAccountRegistrationErrorInvalidUsername)]);
                expectErrorForBadParameters(@{USERNAME_KEY: @"ab!"}, @[@(RTAccountRegistrationErrorInvalidUsername)]);
            });
        });
        
        describe(@"invalid password", ^{
            it(@"matches confirmation password but is too short", ^{
                expectErrorForBadParameters(@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: @"a"},
                                            @[@(RTAccountRegistrationErrorInvalidPassword)]);
                
                expectErrorForBadParameters(@{PASSWORD_KEY: @"abcde", CONFIRMATION_PASSWORD_KEY: @"abcde"},
                                            @[@(RTAccountRegistrationErrorInvalidPassword)]);
            });

            // TODO: Explore this more
            xit(@"does not count control characters", ^{
                expectErrorForBadParameters(@{PASSWORD_KEY: @"abcd\n"}, @[@(RTAccountRegistrationErrorInvalidPassword)]);
                expectErrorForBadParameters(@{PASSWORD_KEY: @"abcde\n"}, @[@(RTAccountRegistrationErrorInvalidPassword)]);
            });
            
            it(@"does not match confirmation password", ^{
                expectErrorForBadParameters(@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: BLANK},
                                            @[@(RTAccountRegistrationErrorMissingPassword),
                                              @(RTAccountRegistrationErrorMissingConfirmationPassword)]);
                
                expectErrorForBadParameters(@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"a"},
                                            @[@(RTAccountRegistrationErrorMissingPassword)]);
                
                expectErrorForBadParameters(@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: BLANK},
                                            @[@(RTAccountRegistrationErrorInvalidPassword),
                                              @(RTAccountRegistrationErrorMissingConfirmationPassword)]);
                
                expectErrorForBadParameters(@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: BLANK},
                                            @[@(RTAccountRegistrationErrorMissingConfirmationPassword)]);
                
                expectErrorForBadParameters(@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"abcdef"},
                                            @[@(RTAccountRegistrationErrorMissingPassword)]);
                
                expectErrorForBadParameters(@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: @"ABCDEF"},
                                            @[@(RTAccountRegistrationErrorConfirmationPasswordDoesNotMatch)]);
            });
        });
        
        describe(@"invalid email", ^{
            it(@"does not match email regex", ^{
                expectErrorForBadParameters(@{EMAIL_KEY: @"oops"}, @[@(RTAccountRegistrationErrorInvalidEmail)]);
                expectErrorForBadParameters(@{EMAIL_KEY: @"foo@"}, @[@(RTAccountRegistrationErrorInvalidEmail)]);
                expectErrorForBadParameters(@{EMAIL_KEY: @"foo@b"}, @[@(RTAccountRegistrationErrorInvalidEmail)]);
                expectErrorForBadParameters(@{EMAIL_KEY: @"@coffee"}, @[@(RTAccountRegistrationErrorInvalidEmail)]);
            });
        });
        
        describe(@"invalid display name", ^{
            it(@"too short", ^{
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @"a"}, @[@(RTAccountRegistrationErrorInvalidDisplayName)]);
            });
            
            it(@"too long", ^{
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @"123456789012345678901"},
                                            @[@(RTAccountRegistrationErrorInvalidDisplayName)]);
            });
            
            it(@"cannot contain leading or trailing space", ^{
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @" "}, @[@(RTAccountRegistrationErrorInvalidDisplayName)]);
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @" a"}, @[@(RTAccountRegistrationErrorInvalidDisplayName)]);
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @"a "}, @[@(RTAccountRegistrationErrorInvalidDisplayName)]);
            });
            
            it(@"cannot contain non-word characters", ^{
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @"!a"}, @[@(RTAccountRegistrationErrorInvalidDisplayName)]);
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @"!ab"}, @[@(RTAccountRegistrationErrorInvalidDisplayName)]);
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @"1234567890123456789!"},
                                            @[@(RTAccountRegistrationErrorInvalidDisplayName)]);
            });
        });
    });
});

SpecEnd