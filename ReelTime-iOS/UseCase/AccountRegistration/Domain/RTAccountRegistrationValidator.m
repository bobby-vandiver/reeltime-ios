#import "RTAccountRegistrationValidator.h"
#import "RTAccountRegistration.h"

#import "RTRegexPattern.h"
#import "RTErrorFactory.h"

@implementation RTAccountRegistrationValidator

- (BOOL)validateAccountRegistration:(RTAccountRegistration *)registration
                             errors:(NSArray *__autoreleasing *)errors {
    
    return [super validateWithErrors:errors validationBlock:^(NSMutableArray *errorContainer) {
        [self validateUsername:registration.username errors:errorContainer];
        [self validatePassword:registration.password confirmationPassword:registration.confirmationPassword errors:errorContainer];
        
        [self validateEmail:registration.email errors:errorContainer];
        [self validateDisplayName:registration.displayName errors:errorContainer];
        
        [self validateClientName:registration.clientName errors:errorContainer];
    }];
}

- (void)validateUsername:(NSString *)username
                  errors:(NSMutableArray *)errors {
    if ([username length] == 0) {
        [self addRegistrationErrorCode:RTAccountRegistrationErrorMissingUsername toErrors:errors];
    }
    else {
        NSString *pattern = [NSString stringWithFormat:@"^%@$", USERNAME_PATTERN];

        [self validateParameter:username
                    withPattern:pattern
               invalidErrorCode:RTAccountRegistrationErrorInvalidUsername
                         errors:errors];
    }
}

- (void)validatePassword:(NSString *)password
    confirmationPassword:(NSString *)confirmationPassword
                  errors:(NSMutableArray *)errors {
    if ([password length] == 0) {
        [self addRegistrationErrorCode:RTAccountRegistrationErrorMissingPassword toErrors:errors];
    }
    else if ([password length] < PASSWORD_MINIMUM_LENGTH) {
        [self addRegistrationErrorCode:RTAccountRegistrationErrorInvalidPassword toErrors:errors];
    }
    
    if ([confirmationPassword length] == 0) {
        [self addRegistrationErrorCode:RTAccountRegistrationErrorMissingConfirmationPassword toErrors:errors];
    }
    else if ([password length] >= PASSWORD_MINIMUM_LENGTH && ![confirmationPassword isEqualToString:password]) {
        [self addRegistrationErrorCode:RTAccountRegistrationErrorConfirmationPasswordDoesNotMatch toErrors:errors];
    }
}

- (void)validateEmail:(NSString *)email
               errors:(NSMutableArray *)errors {
    if ([email length] == 0) {
        [self addRegistrationErrorCode:RTAccountRegistrationErrorMissingEmail toErrors:errors];
    }
    else {
        [self validateParameter:email
                    withPattern:EMAIL_REGEX
               invalidErrorCode:RTAccountRegistrationErrorInvalidEmail
                         errors:errors];
    }
}

- (void)validateDisplayName:(NSString *)displayName
                     errors:(NSMutableArray *)errors {
    if ([displayName length] == 0) {
        [self addRegistrationErrorCode:RTAccountRegistrationErrorMissingDisplayName toErrors:errors];
    }
    else {
        [self validateParameter:displayName
                    withPattern:DISPLAY_NAME_REGEX
               invalidErrorCode:RTAccountRegistrationErrorInvalidDisplayName
                         errors:errors];
    }
}

- (void)validateClientName:(NSString *)clientName
                    errors:(NSMutableArray *)errors {
    if ([clientName length] == 0) {
        [self addRegistrationErrorCode:RTAccountRegistrationErrorMissingClientName toErrors:errors];
    }
}

- (void)validateParameter:(NSString *)parameter
              withPattern:(NSString *)pattern
         invalidErrorCode:(NSInteger)code
                   errors:(NSMutableArray *)errors {
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL matches = [regexPredicate evaluateWithObject:parameter];

    if (!matches) {
        [self addRegistrationErrorCode:code toErrors:errors];
    }
}

- (void)addRegistrationErrorCode:(RTAccountRegistrationError)code
                        toErrors:(NSMutableArray *)errors {
    NSError *error = [RTErrorFactory accountRegistrationErrorWithCode:code];
    [errors addObject:error];
}

@end
