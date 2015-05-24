#import "RTResetPasswordValidator.h"
#import "RTResetPasswordError.h"

#import "RTPasswordValidationMapping.h"

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

        RTPasswordValidationMapping *mapping = [self passwordValidationMapping];
        [self validatePassword:password confirmationPassword:confirmationPassword withMapping:mapping errors:errorContainer];
    }];
}

- (BOOL)validateCode:(NSString *)code
            username:(NSString *)username
            password:(NSString *)password
confirmationPassword:(NSString *)confirmationPassword
          clientName:(NSString *)clientName
              errors:(NSArray *__autoreleasing *)errors {

    return [super validateWithErrors:errors validationBlock:^(NSMutableArray *errorContainer) {
        [self validateCode:code errors:errorContainer];
        [self validateUsername:username errors:errorContainer];

        RTPasswordValidationMapping *mapping = [self passwordValidationMapping];
        [self validatePassword:password confirmationPassword:confirmationPassword withMapping:mapping errors:errorContainer];
        
        [self validateClientName:clientName errors:errorContainer];
    }];
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

- (void)validateClientName:(NSString *)clientName
                    errors:(NSMutableArray *)errors {
    if (clientName.length == 0) {
        [self addResetErrorCode:RTResetPasswordErrorMissingClientName toErrors:errors];
    }
}

- (void)addResetErrorCode:(RTResetPasswordError)code
                 toErrors:(NSMutableArray *)errors {
    NSError *error = [RTErrorFactory resetPasswordErrorWithCode:code];
    [errors addObject:error];
}

- (RTPasswordValidationMapping *)passwordValidationMapping {
    return [RTPasswordValidationMapping mappingWithErrorDomain:RTResetPasswordErrorDomain
                                      missingPasswordErrorCode:RTResetPasswordErrorMissingPassword
                                      invalidPasswordErrorCode:RTResetPasswordErrorInvalidPassword
                          missingConfirmationPasswordErrorCode:RTResetPasswordErrorMissingConfirmationPassword
                         confirmationPasswordMismatchErrorCode:RTResetPasswordErrorConfirmationPasswordDoesNotMatch];
}

@end
