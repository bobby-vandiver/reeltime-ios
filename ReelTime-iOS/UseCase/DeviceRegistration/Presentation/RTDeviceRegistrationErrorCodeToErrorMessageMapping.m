#import "RTDeviceRegistrationErrorCodeToErrorMessageMapping.h"
#import "RTDeviceRegistrationError.h"

@implementation RTDeviceRegistrationErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTDeviceRegistrationErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTDeviceRegistrationErrorMissingUsername): @"Username is required",
             @(RTDeviceRegistrationErrorMissingPassword): @"Password is required",
             @(RTDeviceRegistrationErrorMissingClientName): @"Client name is required",
             @(RTDeviceRegistrationErrorInvalidCredentials): @"Invalid username or password",
             @(RTDeviceRegistrationErrorUnableToStoreClientCredentials): @"This device was registered but a problem occurred while completing the registration. Please register under a different name or unregister the current device from a different device and try again.",
             @(RTDeviceRegistrationErrorServiceUnavailable): @"Unable to register a device at this time. Please try again shortly."
             };
}

@end
