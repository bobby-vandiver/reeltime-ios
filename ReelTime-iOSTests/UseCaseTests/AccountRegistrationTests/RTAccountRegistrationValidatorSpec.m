#import "RTTestCommon.h"

#import "RTAccountRegistration.h"
#import "RTAccountRegistrationValidator.h"
#import "RTAccountRegistrationErrors.h"
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

    void (^expectErrorForBadParameters)(NSDictionary *parameters, NSArray *expectedErrorCodes) =
    ^(NSDictionary *parameters, NSArray *expectedErrorCodes) {
        
        NSString *usernameParam = [parameters objectForKey:USERNAME_KEY];
        NSString *passwordParam = [parameters objectForKey:PASSWORD_KEY];
        NSString *confirmationParam = [parameters objectForKey:CONFIRMATION_PASSWORD_KEY];
        NSString *emailParam = [parameters objectForKey:EMAIL_KEY];
        NSString *displayNameParam = [parameters objectForKey:DISPLAY_NAME_KEY];
        NSString *clientNameParam = [parameters objectForKey:CLIENT_NAME_KEY];
        
        RTAccountRegistration *registration = [RTAccountRegistration alloc];
        registration = [registration initWithUsername:(usernameParam ? usernameParam : username)
                                             password:(passwordParam ? passwordParam : password)
                                 confirmationPassword:(confirmationParam ? confirmationParam : password)
                                                email:(emailParam ? emailParam : email)
                                          displayName:(displayNameParam ? displayNameParam : displayName)
                                           clientName:(clientNameParam ? clientNameParam : clientName)];
        
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

    // TODO: Test nil values
    context(@"missing parameters", ^{
        it(@"blank username", ^{
            expectErrorForBadParameters(@{USERNAME_KEY: BLANK}, @[@(AccountRegistrationMissingUsername)]);
        });
        
        it(@"blank password", ^{
            expectErrorForBadParameters(@{PASSWORD_KEY: BLANK}, @[@(AccountRegistrationMissingPassword)]);
        });
        
        it(@"blank confirmation password", ^{
            expectErrorForBadParameters(@{CONFIRMATION_PASSWORD_KEY: BLANK}, @[@(AccountRegistrationMissingConfirmationPassword)]);
        });
        
        it(@"blank email", ^{
            expectErrorForBadParameters(@{EMAIL_KEY: BLANK}, @[@(AccountRegistrationMissingEmail)]);
        });
        
        it(@"blank display name", ^{
            expectErrorForBadParameters(@{DISPLAY_NAME_KEY: BLANK}, @[@(AccountRegistrationMissingDisplayName)]);
        });
        
        it(@"blank client name", ^{
            expectErrorForBadParameters(@{CLIENT_NAME_KEY: BLANK}, @[@(AccountRegistrationMissingClientName)]);
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
                                            @(AccountRegistrationMissingUsername),
                                            @(AccountRegistrationMissingPassword),
                                            @(AccountRegistrationMissingConfirmationPassword),
                                            @(AccountRegistrationMissingEmail),
                                            @(AccountRegistrationMissingDisplayName),
                                            @(AccountRegistrationMissingClientName)
                                            ];
            
            expectErrorForBadParameters(parameters, expectedErrorCodes);
        });
    });
    
    context(@"invalid parameters", ^{
        
        describe(@"invalid username", ^{
            it(@"too short", ^{
                expectErrorForBadParameters(@{USERNAME_KEY: @"a"}, @[@(AccountRegistrationInvalidUsername)]);
            });
            
            it(@"too long", ^{
                expectErrorForBadParameters(@{USERNAME_KEY: @"abcdefghijklmnop"}, @[@(AccountRegistrationInvalidUsername)]);
                expectErrorForBadParameters(@{USERNAME_KEY: @"aBcdEFghIjklmnop1234"}, @[@(AccountRegistrationInvalidUsername)]);
            });
            
            it(@"cannot contain space", ^{
                expectErrorForBadParameters(@{USERNAME_KEY: @"a b"}, @[@(AccountRegistrationInvalidUsername)]);
                expectErrorForBadParameters(@{USERNAME_KEY: @" ab"}, @[@(AccountRegistrationInvalidUsername)]);
                expectErrorForBadParameters(@{USERNAME_KEY: @"ab "}, @[@(AccountRegistrationInvalidUsername)]);
            });
            
            it(@"invalid characters", ^{
                expectErrorForBadParameters(@{USERNAME_KEY: @"!ab"}, @[@(AccountRegistrationInvalidUsername)]);
                expectErrorForBadParameters(@{USERNAME_KEY: @"a!b"}, @[@(AccountRegistrationInvalidUsername)]);
                expectErrorForBadParameters(@{USERNAME_KEY: @"ab!"}, @[@(AccountRegistrationInvalidUsername)]);
            });
        });
        
        describe(@"invalid password", ^{
            it(@"matches confirmation password but is too short", ^{
                expectErrorForBadParameters(@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: @"a"},
                                            @[@(AccountRegistrationInvalidPassword)]);
                
                expectErrorForBadParameters(@{PASSWORD_KEY: @"abcde", CONFIRMATION_PASSWORD_KEY: @"abcde"},
                                            @[@(AccountRegistrationInvalidPassword)]);
            });

            // TODO: Explore this more
            xit(@"does not count control characters", ^{
                expectErrorForBadParameters(@{PASSWORD_KEY: @"abcd\n"}, @[@(AccountRegistrationInvalidPassword)]);
                expectErrorForBadParameters(@{PASSWORD_KEY: @"abcde\n"}, @[@(AccountRegistrationInvalidPassword)]);
            });
            
            it(@"does not match confirmation password", ^{
                expectErrorForBadParameters(@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: BLANK},
                                            @[@(AccountRegistrationMissingPassword),
                                              @(AccountRegistrationMissingConfirmationPassword)]);
                
                expectErrorForBadParameters(@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"a"},
                                            @[@(AccountRegistrationMissingPassword)]);
                
                expectErrorForBadParameters(@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: BLANK},
                                            @[@(AccountRegistrationInvalidPassword),
                                              @(AccountRegistrationMissingConfirmationPassword)]);
                
                expectErrorForBadParameters(@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: BLANK},
                                            @[@(AccountRegistrationMissingConfirmationPassword)]);
                
                expectErrorForBadParameters(@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"abcdef"},
                                            @[@(AccountRegistrationMissingPassword)]);
                
                expectErrorForBadParameters(@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: @"ABCDEF"},
                                            @[@(AccountRegistrationConfirmationPasswordDoesNotMatch)]);
            });
        });
        
        describe(@"invalid email", ^{
            it(@"does not match email regex", ^{
                expectErrorForBadParameters(@{EMAIL_KEY: @"oops"}, @[@(AccountRegistrationInvalidEmail)]);
                expectErrorForBadParameters(@{EMAIL_KEY: @"foo@"}, @[@(AccountRegistrationInvalidEmail)]);
                expectErrorForBadParameters(@{EMAIL_KEY: @"foo@b"}, @[@(AccountRegistrationInvalidEmail)]);
                expectErrorForBadParameters(@{EMAIL_KEY: @"@coffee"}, @[@(AccountRegistrationInvalidEmail)]);
            });
        });
        
        describe(@"invalid display name", ^{
            it(@"too short", ^{
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @"a"}, @[@(AccountRegistrationInvalidDisplayName)]);
            });
            
            it(@"too long", ^{
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @"123456789012345678901"},
                                            @[@(AccountRegistrationInvalidDisplayName)]);
            });
            
            it(@"cannot contain leading or trailing space", ^{
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @" "}, @[@(AccountRegistrationInvalidDisplayName)]);
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @" a"}, @[@(AccountRegistrationInvalidDisplayName)]);
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @"a "}, @[@(AccountRegistrationInvalidDisplayName)]);
            });
            
            it(@"cannot contain non-word characters", ^{
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @"!a"}, @[@(AccountRegistrationInvalidDisplayName)]);
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @"!ab"}, @[@(AccountRegistrationInvalidDisplayName)]);
                expectErrorForBadParameters(@{DISPLAY_NAME_KEY: @"1234567890123456789!"}, @[@(AccountRegistrationInvalidDisplayName)]);
            });
        });
    });
});

SpecEnd