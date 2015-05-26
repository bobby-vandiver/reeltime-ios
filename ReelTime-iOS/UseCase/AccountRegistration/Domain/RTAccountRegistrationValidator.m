#import "RTAccountRegistrationValidator.h"
#import "RTAccountRegistration.h"

#import "RTPasswordValidationMapping.h"

#import "RTRegexPattern.h"
#import "RTErrorFactory.h"

@implementation RTAccountRegistrationValidator

- (BOOL)validateAccountRegistration:(RTAccountRegistration *)registration
                             errors:(NSArray *__autoreleasing *)errors {
    
    return [super validateWithErrors:errors validationBlock:^(NSMutableArray *errorContainer) {
        RTPasswordValidationMapping *mapping = [self passwordValidationMapping];
        
        [self validateUsername:registration.username errors:errorContainer];
        [self validatePassword:registration.password confirmationPassword:registration.confirmationPassword withMapping:mapping errors:errorContainer];
        
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
    [self validateDisplayName:displayName
                   withDomain:RTAccountRegistrationErrorDomain
                  missingCode:RTAccountRegistrationErrorMissingDisplayName
                  invalidCode:RTAccountRegistrationErrorInvalidDisplayName
                       errors:errors];
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
    [self validateParameter:parameter withPattern:pattern domain:RTAccountRegistrationErrorDomain code:code errors:errors];
}

- (void)addRegistrationErrorCode:(RTAccountRegistrationError)code
                        toErrors:(NSMutableArray *)errors {
    NSError *error = [RTErrorFactory accountRegistrationErrorWithCode:code];
    [errors addObject:error];
}

- (RTPasswordValidationMapping *)passwordValidationMapping {
    return [RTPasswordValidationMapping mappingWithErrorDomain:RTAccountRegistrationErrorDomain
                                      missingPasswordErrorCode:RTAccountRegistrationErrorMissingPassword
                                      invalidPasswordErrorCode:RTAccountRegistrationErrorInvalidPassword
                          missingConfirmationPasswordErrorCode:RTAccountRegistrationErrorMissingConfirmationPassword
                         confirmationPasswordMismatchErrorCode:RTAccountRegistrationErrorConfirmationPasswordDoesNotMatch];
}

@end
