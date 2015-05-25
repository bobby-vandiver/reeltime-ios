#import "RTChangePasswordErrorCodeToErrorMessageMapping.h"
#import "RTChangePasswordError.h"

@implementation RTChangePasswordErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTChangePasswordErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTChangePasswordErrorMissingPassword): @"Password is required",
             @(RTChangePasswordErrorInvalidPassword): @"Password must be at least 6 characters",
             @(RTChangePasswordErrorMissingConfirmationPassword): @"Confirmation password is required",
             @(RTChangePasswordErrorConfirmationPasswordDoesNotMatch): @"Password and confirmation password must match"
             };
}

@end
