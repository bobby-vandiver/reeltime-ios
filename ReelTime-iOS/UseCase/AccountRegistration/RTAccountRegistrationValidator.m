#import "RTAccountRegistrationValidator.h"
#import "RTAccountRegistration.h"

#import "RTErrorFactory.h"

NSString *const USERNAME_REGEX = @"^\\w{2,15}$";
const NSInteger PASSWORD_MINIMUM_LENGTH = 6;

@implementation RTAccountRegistrationValidator

- (BOOL)validateAccountRegistration:(RTAccountRegistration *)registration
                             errors:(NSArray *__autoreleasing *)errors {
    BOOL valid = YES;
    NSMutableArray *errorContainer = [NSMutableArray array];
    
    [self validateUsername:registration.username errors:errorContainer];
    [self validatePassword:registration.password confirmationPassword:registration.confirmationPassword errors:errorContainer];
    
    if ([registration.email length] == 0) {
        [self addRegistrationErrorCode:AccountRegistrationMissingEmail toErrors:errorContainer];
    }
    if ([registration.displayName length] == 0) {
        [self addRegistrationErrorCode:AccountRegistrationMissingDisplayName toErrors:errorContainer];
    }
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

- (void)validateParameter:(NSString *)parameter
              withPattern:(NSString *)pattern
         invalidErrorCode:(NSInteger)code
                   errors:(NSMutableArray *)errors {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:nil];
    
    NSUInteger matches = [regex numberOfMatchesInString:parameter
                                                options:0
                                                  range:NSMakeRange(0, [parameter length])];
    if (matches < 1) {
        [self addRegistrationErrorCode:code toErrors:errors];
    }
}

- (void)addRegistrationErrorCode:(RTAccountRegistrationErrors)code
                        toErrors:(NSMutableArray *)errors {
    NSError *error = [RTErrorFactory accountRegistrationErrorWithCode:code];
    [errors addObject:error];
}

@end