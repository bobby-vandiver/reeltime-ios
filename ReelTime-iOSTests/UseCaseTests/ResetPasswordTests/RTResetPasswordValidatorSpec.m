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
    NSString *const NEW_PASSWORD_KEY = @"newPassword";
    NSString *const CLIENT_NAME_KEY = @"clientName";

    void (^expectErrorForBadParametersForRegisteredClient)(NSDictionary *parameters, NSArray *expectedErrorCodes) =
    ^(NSDictionary *parameters, NSArray *expectedErrorCodes) {
        
        NSString *codeParam = parameters[CODE_KEY];
        NSString *usernameParam = parameters[USERNAME_KEY];
        NSString *newPasswordParam = parameters[NEW_PASSWORD_KEY];
        
        NSArray *errors;
        BOOL valid = [validator validateCode:getParameterOrDefault(codeParam, resetCode)
                                    username:getParameterOrDefault(usernameParam, username)
                                    password:getParameterOrDefault(newPasswordParam, password)
                                      errors:&errors];
        
        expect(valid).to.beFalsy();
        expect(errors).to.haveACountOf(expectedErrorCodes.count);
        
        for (NSNumber *errorCode in expectedErrorCodes) {
            NSError *expected = [RTErrorFactory resetPasswordErrorWithCode:[errorCode integerValue]];
            expect(errors).to.contain(expected);
        }
    };
    
    beforeEach(^{
        validator = [[RTResetPasswordValidator alloc] init];
    });
    
    context(@"missing parameters", ^{
        it(@"blank code", ^{
            expectErrorForBadParametersForRegisteredClient(@{CODE_KEY: BLANK}, @[@(RTResetPasswordErrorMissingResetCode)]);
            expectErrorForBadParametersForRegisteredClient(@{CODE_KEY: [NSNull null]}, @[@(RTResetPasswordErrorMissingResetCode)]);
        });
        
        it(@"blank username", ^{
            expectErrorForBadParametersForRegisteredClient(@{USERNAME_KEY: BLANK}, @[@(RTResetPasswordErrorMissingUsername)]);
            expectErrorForBadParametersForRegisteredClient(@{USERNAME_KEY: [NSNull null]}, @[@(RTResetPasswordErrorMissingUsername)]);
        });
        
        it(@"blank password", ^{
            expectErrorForBadParametersForRegisteredClient(@{NEW_PASSWORD_KEY: BLANK}, @[@(RTResetPasswordErrorMissingNewPassword)]);
            expectErrorForBadParametersForRegisteredClient(@{NEW_PASSWORD_KEY: [NSNull null]}, @[@(RTResetPasswordErrorMissingNewPassword)]);
        });
    });
});

SpecEnd