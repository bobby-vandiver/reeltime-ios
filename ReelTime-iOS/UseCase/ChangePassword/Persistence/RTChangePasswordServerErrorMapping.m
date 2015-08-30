#import "RTChangePasswordServerErrorMapping.h"
#import "RTChangePasswordError.h"

@implementation RTChangePasswordServerErrorMapping

- (NSString *)errorDomain {
    return RTChangePasswordErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"[new_password] is required": @(RTChangePasswordErrorMissingPassword),
             @"[new_password] must be at least 6 characters long": @(RTChangePasswordErrorInvalidPassword)
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTChangePasswordErrorUnknownError;
}

@end
