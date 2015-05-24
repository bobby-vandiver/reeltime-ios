#import "RTValidator.h"

#import "RTPasswordValidationMapping.h"
#import "RTRegexPattern.h"

@implementation RTValidator

- (BOOL)validateWithErrors:(NSArray *__autoreleasing *)errors
           validationBlock:(void (^)(NSMutableArray *errorContainer))validationBlock {
    BOOL valid = YES;

    NSMutableArray *errorContainer = [NSMutableArray array];
    validationBlock(errorContainer);
    
    if (errorContainer.count > 0) {
        valid = NO;
        
        if (errors) {
            *errors = errorContainer;
        }
    }
    
    return valid;
}

- (void)validatePassword:(NSString *)password
    confirmationPassword:(NSString *)confirmationPassword
             withMapping:(RTPasswordValidationMapping *)mapping
                  errors:(NSMutableArray *)errors {
    if (password.length == 0) {
        [self addErrorWithDomain:mapping.errorDomain
                            code:mapping.missingPasswordErrorCode
                        toErrors:errors];
    }
    else if (password.length < PASSWORD_MINIMUM_LENGTH) {
        [self addErrorWithDomain:mapping.errorDomain
                            code:mapping.invalidPasswordErrorCode
                        toErrors:errors];
    }
    
    if (confirmationPassword.length == 0) {
        [self addErrorWithDomain:mapping.errorDomain
                            code:mapping.missingConfirmationPasswordErrorCode
                        toErrors:errors];
    }
    else if (password.length >= PASSWORD_MINIMUM_LENGTH && ![confirmationPassword isEqualToString:password]) {
        [self addErrorWithDomain:mapping.errorDomain
                            code:mapping.confirmationPasswordMismatchErrorCode
                        toErrors:errors];
    }
}

- (void)addErrorWithDomain:(NSString *)domain
                      code:(NSInteger)code
                  toErrors:(NSMutableArray *)errors {
    NSError *error = [NSError errorWithDomain:domain code:code userInfo:nil];
    [errors addObject:error];
}

@end
