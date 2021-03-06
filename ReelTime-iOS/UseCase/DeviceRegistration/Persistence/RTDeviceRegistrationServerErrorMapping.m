#import "RTDeviceRegistrationServerErrorMapping.h"
#import "RTDeviceRegistrationError.h"

@implementation RTDeviceRegistrationServerErrorMapping

- (NSString *)errorDomain {
    return RTDeviceRegistrationErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"[username] is required": @(RTDeviceRegistrationErrorMissingUsername),
             @"[password] is required": @(RTDeviceRegistrationErrorMissingPassword),
             @"[client_name] is required": @(RTDeviceRegistrationErrorMissingClientName),
             @"Invalid credentials": @(RTDeviceRegistrationErrorInvalidCredentials),
             @"Unable to register. Please try again.": @(RTDeviceRegistrationErrorServiceUnavailable)
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTDeviceRegistrationErrorUnknownError;
}

@end
