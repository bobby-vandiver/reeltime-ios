#import "RTResetPasswordValidator.h"
#import "RTResetPasswordError.h"

#import "RTRegexPattern.h"
#import "RTErrorFactory.h"

@implementation RTResetPasswordValidator

- (BOOL)validateCode:(NSString *)code
            username:(NSString *)username
            password:(NSString *)password
confirmationPassword:(NSString *)confirmationPassword
              errors:(NSArray *__autoreleasing *)errors {
    
    return [super validateWithErrors:errors validationBlock:^(NSMutableArray *errorContainer) {
        [self validateCode:code errors:errorContainer];
        
        [self validateUsername:username errors:errorContainer];
        [self validatePassword:password confirmationPassword:confirmationPassword errors:errorContainer];
    }];
}

- (BOOL)validateCode:(NSString *)code
            username:(NSString *)username
            password:(NSString *)password
confirmationPassword:(NSString *)confirmationPassword
          clientName:(NSString *)clientName
              errors:(NSArray *__autoreleasing *)errors {
    return NO;
}

- (void)validateCode:(NSString *)code
              errors:(NSMutableArray *)errors {
    if (code.length == 0) {
        [self addResetErrorCode:RTResetPasswordErrorMissingResetCode toErrors:errors];
    }
}

- (void)validateUsername:(NSString *)username
                  errors:(NSMutableArray *)errors {
    if (username.length == 0) {
        [self addResetErrorCode:RTResetPasswordErrorMissingUsername toErrors:errors];
    }
}

- (void)validatePassword:(NSString *)password
    confirmationPassword:(NSString *)confirmationPassword
                  errors:(NSMutableArray *)errors {
    if (password.length == 0) {
        [self addResetErrorCode:RTResetPasswordErrorMissingPassword toErrors:errors];
    }
    else if (password.length < PASSWORD_MINIMUM_LENGTH) {
        [self addResetErrorCode:RTResetPasswordErrorInvalidPassword toErrors:errors];
    }
    
    if (confirmationPassword.length == 0) {
        [self addResetErrorCode:RTResetPasswordErrorMissingConfirmationPassword toErrors:errors];
    }
    else if (password.length >= PASSWORD_MINIMUM_LENGTH && ![confirmationPassword isEqualToString:password]) {
        [self addResetErrorCode:RTResetPasswordErrorConfirmationPasswordDoesNotMatch toErrors:errors];
    }
}

- (void)addResetErrorCode:(RTResetPasswordError)code
                 toErrors:(NSMutableArray *)errors {
    NSError *error = [RTErrorFactory resetPasswordErrorWithCode:code];
    [errors addObject:error];
}

@end
