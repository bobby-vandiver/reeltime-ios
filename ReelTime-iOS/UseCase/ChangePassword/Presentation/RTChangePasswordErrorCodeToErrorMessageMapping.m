#import "RTChangePasswordErrorCodeToErrorMessageMapping.h"
#import "RTChangePasswordError.h"

@implementation RTChangePasswordErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTChangePasswordErrorDomain;
}

/*
 RTChangePasswordErrorMissingPassword,
 RTChangePasswordErrorMissingConfirmationPassword,
 RTChangePasswordErrorInvalidPassword,
 RTChangePasswordErrorConfirmationPasswordDoesNotMatch
 */

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             
             };
}

@end
