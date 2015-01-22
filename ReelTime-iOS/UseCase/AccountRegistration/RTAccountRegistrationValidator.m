#import "RTAccountRegistrationValidator.h"
#import "RTAccountRegistration.h"

#import "RTErrorFactory.h"

NSString *const USERNAME_REGEX = @"^\\w{2,15}$";
const NSInteger PASSWORD_MINIMUM_LENGTH = 6;

NSString *const EMAIL_REGEX = @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
                              @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
                              @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
                              @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
                              @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
                              @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
                              @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";

NSString *const DISPLAY_NAME_REGEX = @"^\\w{1}[\\w ]{0,18}?\\w{1}$";

@implementation RTAccountRegistrationValidator

- (BOOL)validateAccountRegistration:(RTAccountRegistration *)registration
                             errors:(NSArray *__autoreleasing *)errors {
    BOOL valid = YES;
    NSMutableArray *errorContainer = [NSMutableArray array];
    
    [self validateUsername:registration.username errors:errorContainer];
    [self validatePassword:registration.password confirmationPassword:registration.confirmationPassword errors:errorContainer];
    
    [self validateEmail:registration.email errors:errorContainer];
    [self validateDisplayName:registration.displayName errors:errorContainer];
    
    if ([registration.clientName length] == 0) {
        [self addRegistrationErrorCode:AccountRegistrationMissingClientName toErrors:errorContainer];
    }
    
    if ([errorContainer count] > 0) {
        valid = NO;
        
        if (errors) {
            *errors = errorContainer;
        }
    }
    
    return valid;
}

- (void)validateUsername:(NSString *)username
                  errors:(NSMutableArray *)errors {
    if ([username length] == 0) {
        [self addRegistrationErrorCode:AccountRegistrationMissingUsername toErrors:errors];
    }
    else {
        [self validateParameter:username
                    withPattern:USERNAME_REGEX
               invalidErrorCode:AccountRegistrationInvalidUsername
                         errors:errors];
    }
}

- (void)validatePassword:(NSString *)password
    confirmationPassword:(NSString *)confirmationPassword
                  errors:(NSMutableArray *)errors {
    if ([password length] == 0) {
        [self addRegistrationErrorCode:AccountRegistrationMissingPassword toErrors:errors];
    }
    else if ([password length] < PASSWORD_MINIMUM_LENGTH) {
        [self addRegistrationErrorCode:AccountRegistrationInvalidPassword toErrors:errors];
    }
    
    if ([confirmationPassword length] == 0) {
        [self addRegistrationErrorCode:AccountRegistrationMissingConfirmationPassword toErrors:errors];
    }
    else if ([password length] >= PASSWORD_MINIMUM_LENGTH && ![confirmationPassword isEqualToString:password]) {
        [self addRegistrationErrorCode:AccountRegistrationConfirmationPasswordDoesNotMatch toErrors:errors];
    }
}

- (void)validateEmail:(NSString *)email
               errors:(NSMutableArray *)errors {
    if ([email length] == 0) {
        [self addRegistrationErrorCode:AccountRegistrationMissingEmail toErrors:errors];
    }
    else {
        [self validateParameter:email
                    withPattern:EMAIL_REGEX
               invalidErrorCode:AccountRegistrationInvalidEmail
                         errors:errors];
    }
}

- (void)validateDisplayName:(NSString *)displayName
                     errors:(NSMutableArray *)errors {
    if ([displayName length] == 0) {
        [self addRegistrationErrorCode:AccountRegistrationMissingDisplayName toErrors:errors];
    }
    else {
        [self validateParameter:displayName
                    withPattern:DISPLAY_NAME_REGEX
               invalidErrorCode:AccountRegistrationInvalidDisplayName
                         errors:errors];
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

- (void)addRegistrationErrorCode:(RTAccountRegistrationErrors)code
                        toErrors:(NSMutableArray *)errors {
    NSError *error = [RTErrorFactory accountRegistrationErrorWithCode:code];
    [errors addObject:error];
}

@end
