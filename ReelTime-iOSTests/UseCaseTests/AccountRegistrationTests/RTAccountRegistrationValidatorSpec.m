#import "RTTestCommon.h"

#import "RTAccountRegistration.h"
#import "RTAccountRegistrationValidator.h"
#import "RTAccountRegistrationError.h"
#import "RTErrorFactory.h"

SpecBegin(RTAccountRegistrationValidator)

describe(@"account registration validator", ^{
    
    __block RTAccountRegistrationValidator *validator;
    __block RTValidationTestHelper *helper;
    
    ValidationCallback validationCallback = ^BOOL (NSDictionary *parameters, NSArray *__autoreleasing *errors) {
        NSString *usernameParam = parameters[USERNAME_KEY];
        NSString *passwordParam = parameters[PASSWORD_KEY];
        NSString *confirmationParam = parameters[CONFIRMATION_PASSWORD_KEY];
        NSString *emailParam = parameters[EMAIL_KEY];
        NSString *displayNameParam = parameters[DISPLAY_NAME_KEY];
        NSString *clientNameParam = parameters[CLIENT_NAME_KEY];
        
        RTAccountRegistration *registration = [RTAccountRegistration alloc];
        registration = [registration initWithUsername:getParameterOrDefault(usernameParam, username)
                                             password:getParameterOrDefault(passwordParam, password)
                                 confirmationPassword:getParameterOrDefault(confirmationParam, password)
                                                email:getParameterOrDefault(emailParam, email)
                                          displayName:getParameterOrDefault(displayNameParam, displayName)
                                           clientName:getParameterOrDefault(clientNameParam, clientName)];
        
        return [validator validateAccountRegistration:registration errors:errors];
    };
    
    ErrorFactoryCallback errorFactoryCallback = ^NSError * (NSInteger errorCode) {
        return [RTErrorFactory accountRegistrationErrorWithCode:errorCode];
    };
    
    beforeEach(^{
        validator = [[RTAccountRegistrationValidator alloc] init];
        helper = [[RTValidationTestHelper alloc] initWithValidationCallback:validationCallback
                                                       errorFactoryCallback:errorFactoryCallback];
    });

    context(@"missing parameters", ^{
        it(@"blank username", ^{
            [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingUsername)] forParameters:@{USERNAME_KEY: BLANK}];
            [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingUsername)] forParameters:@{USERNAME_KEY: null()}];
        });
        
        it(@"blank password", ^{
            [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingPassword)] forParameters:@{PASSWORD_KEY: BLANK}];
            [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingPassword)] forParameters:@{PASSWORD_KEY: null()}];
        });
        
        it(@"blank confirmation password", ^{
            [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingConfirmationPassword)] forParameters:@{CONFIRMATION_PASSWORD_KEY: BLANK}];
            [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingConfirmationPassword)] forParameters:@{CONFIRMATION_PASSWORD_KEY: null()}];
        });
        
        it(@"blank email", ^{
            [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingEmail)] forParameters:@{EMAIL_KEY: BLANK}];
            [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingEmail)] forParameters:@{EMAIL_KEY: null()}];
        });
        
        it(@"blank display name", ^{
            [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingDisplayName)] forParameters:@{DISPLAY_NAME_KEY: BLANK}];
            [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingDisplayName)] forParameters:@{DISPLAY_NAME_KEY: null()}];
        });
        
        it(@"blank client name", ^{
            [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingClientName)] forParameters:@{CLIENT_NAME_KEY: BLANK}];
            [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingClientName)] forParameters:@{CLIENT_NAME_KEY: null()}];
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
            
            [helper expectErrorCodes:expectedErrorCodes forParameters:parameters];
        });
    });
    
    context(@"invalid parameters", ^{
        
        describe(@"invalid username", ^{
            it(@"too short", ^{
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidUsername)] forParameters:@{USERNAME_KEY: @"a"}];
            });
            
            it(@"too long", ^{
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidUsername)] forParameters:@{USERNAME_KEY: @"abcdefghijklmnop"}];
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidUsername)] forParameters:@{USERNAME_KEY: @"aBcdEFghIjklmnop1234"}];
            });
            
            it(@"cannot contain space", ^{
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidUsername)] forParameters:@{USERNAME_KEY: @"a b"}];
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidUsername)] forParameters:@{USERNAME_KEY: @" ab"}];
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidUsername)] forParameters:@{USERNAME_KEY: @"ab "}];
            });
            
            it(@"invalid characters", ^{
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidUsername)] forParameters:@{USERNAME_KEY: @"!ab"}];
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidUsername)] forParameters:@{USERNAME_KEY: @"a!b"}];
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidUsername)] forParameters:@{USERNAME_KEY: @"ab!"}];
            });
        });
        
        describe(@"invalid password", ^{
            it(@"matches confirmation password but is too short", ^{
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidPassword)] forParameters:@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: @"a"}];
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidPassword)] forParameters:@{PASSWORD_KEY: @"abcde", CONFIRMATION_PASSWORD_KEY: @"abcde"}];
            });

            // TODO: Explore this more
            xit(@"does not count control characters", ^{
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidPassword)] forParameters:@{PASSWORD_KEY: @"abcd\n"}];
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidPassword)] forParameters:@{PASSWORD_KEY: @"abcde\n"}];
            });
            
            it(@"does not match confirmation password", ^{
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingPassword), @(RTAccountRegistrationErrorMissingConfirmationPassword)]
                           forParameters:@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: BLANK}];
                
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingPassword)]
                           forParameters:@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"a"}];
                
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidPassword), @(RTAccountRegistrationErrorMissingConfirmationPassword)]
                           forParameters:@{PASSWORD_KEY: @"a", CONFIRMATION_PASSWORD_KEY: BLANK}];
                
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingConfirmationPassword)]
                           forParameters:@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: BLANK}];
                
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorMissingPassword)]
                           forParameters:@{PASSWORD_KEY: BLANK, CONFIRMATION_PASSWORD_KEY: @"abcdef"}];
                
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorConfirmationPasswordDoesNotMatch)]
                           forParameters:@{PASSWORD_KEY: @"abcdef", CONFIRMATION_PASSWORD_KEY: @"ABCDEF"}];
            });
        });
        
        describe(@"invalid email", ^{
            it(@"does not match email regex", ^{
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidEmail)] forParameters:@{EMAIL_KEY: @"oops"}];
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidEmail)] forParameters:@{EMAIL_KEY: @"foo@"}];
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidEmail)] forParameters:@{EMAIL_KEY: @"foo@b"}];
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidEmail)] forParameters:@{EMAIL_KEY: @"@coffee"}];
            });
        });
        
        describe(@"invalid display name", ^{
            it(@"too short", ^{
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @"a"}];
            });
            
            it(@"too long", ^{
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @"123456789012345678901"}];
            });
            
            it(@"cannot contain leading or trailing space", ^{
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @" "}];
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @" a"}];
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @"a "}];
            });
            
            it(@"cannot contain non-word characters", ^{
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @"!a"}];
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @"!ab"}];
                [helper expectErrorCodes:@[@(RTAccountRegistrationErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @"1234567890123456789!"}];
            });
        });
    });
});

SpecEnd