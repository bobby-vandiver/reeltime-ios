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

- (void)validateDisplayName:(NSString *)displayName
                 withDomain:(NSString *)domain
                missingCode:(NSInteger)missingCode
                invalidCode:(NSInteger)invalidCode
                     errors:(NSMutableArray *)errors {
    
    if (displayName.length == 0) {
        [self addErrorWithDomain:domain code:missingCode toErrors:errors];
    }
    else {
        [self validateParameter:displayName
                    withPattern:DISPLAY_NAME_REGEX
                         domain:domain
                           code:invalidCode
                         errors:errors];
    }
}

- (void)validateParameter:(NSString *)parameter
              withPattern:(NSString *)pattern
                   domain:(NSString *)domain
                     code:(NSInteger)code
                   errors:(NSMutableArray *)errors {
    
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL matches = [regexPredicate evaluateWithObject:parameter];
    
    if (!matches) {
        [self addErrorWithDomain:domain code:code toErrors:errors];
    }
}

- (void)addErrorWithDomain:(NSString *)domain
                      code:(NSInteger)code
                  toErrors:(NSMutableArray *)errors {
    NSError *error = [NSError errorWithDomain:domain code:code userInfo:nil];
    [errors addObject:error];
}

@end
