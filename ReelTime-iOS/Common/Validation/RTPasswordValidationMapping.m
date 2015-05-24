#import "RTPasswordValidationMapping.h"

@interface RTPasswordValidationMapping ()

@property (readwrite) NSString *errorDomain;

@property (readwrite) NSInteger missingPasswordErrorCode;
@property (readwrite) NSInteger invalidPasswordErrorCode;

@property (readwrite) NSInteger missingConfirmationPasswordErrorCode;
@property (readwrite) NSInteger confirmationPasswordMismatchErrorCode;

@end

@implementation RTPasswordValidationMapping

+ (instancetype)mappingWithErrorDomain:(NSString *)errorDomain
              missingPasswordErrorCode:(NSInteger)missingPasswordErrorCode
              invalidPasswordErrorCode:(NSInteger)invalidPasswordErrorCode
  missingConfirmationPasswordErrorCode:(NSInteger)missingConfirmationPasswordErrorCode
 confirmationPasswordMismatchErrorCode:(NSInteger)confirmationPasswordMismatchErrorCode {
    
    RTPasswordValidationMapping *mapping = [[RTPasswordValidationMapping alloc] init];
    if (mapping) {
        mapping.errorDomain = errorDomain;
        mapping.missingPasswordErrorCode = missingPasswordErrorCode;
        mapping.invalidPasswordErrorCode = invalidPasswordErrorCode;
        mapping.missingConfirmationPasswordErrorCode = missingConfirmationPasswordErrorCode;
        mapping.confirmationPasswordMismatchErrorCode = confirmationPasswordMismatchErrorCode;
    }
    return mapping;
}

@end
