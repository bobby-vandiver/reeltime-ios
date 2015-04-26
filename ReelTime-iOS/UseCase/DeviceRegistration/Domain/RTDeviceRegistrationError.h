#import <Foundation/Foundation.h>

extern NSString *const RTDeviceRegistrationErrorDomain;

typedef NS_ENUM(NSInteger, RTDeviceRegistrationError) {
    RTDeviceRegistrationErrorMissingUsername,
    RTDeviceRegistrationErrorMissingPassword,
    RTDeviceRegistrationErrorMissingClientName, 
    RTDeviceRegistrationErrorInvalidCredentials,
    RTDeviceRegistrationErrorUnableToStoreClientCredentials
};