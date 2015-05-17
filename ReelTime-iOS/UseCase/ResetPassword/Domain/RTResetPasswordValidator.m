#import "RTResetPasswordValidator.h"
#import "RTResetPasswordError.h"
#import "RTErrorFactory.h"

@implementation RTResetPasswordValidator

- (BOOL)validateCode:(NSString *)code
            username:(NSString *)username
            password:(NSString *)password
confirmationPassword:(NSString *)confirmationPassword
              errors:(NSArray *__autoreleasing *)errors {
    BOOL valid = YES;
    NSMutableArray *errorContainer = [NSMutableArray array];
    
    [self validateCode:code errors:errorContainer];
    [self validateUsername:username errors:errorContainer];
    [self validatePassword:password errors:errorContainer];
    
    if (errorContainer.count > 0) {
        valid = NO;
        
        if (errors) {
            *errors = errorContainer;
        }
    }
    
    return valid;
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
                  errors:(NSMutableArray *)errors {
    if (password.length == 0) {
        [self addResetErrorCode:RTResetPasswordErrorMissingNewPassword toErrors:errors];
    }
}

- (void)addResetErrorCode:(RTResetPasswordError)code
                 toErrors:(NSMutableArray *)errors {
    NSError *error = [RTErrorFactory resetPasswordErrorWithCode:code];
    [errors addObject:error];
}

@end
