#import "RTAccountRegistrationServerErrorMapping.h"
#import "RTAccountRegistrationError.h"

@implementation RTAccountRegistrationServerErrorMapping

- (NSString *)errorDomain {
    return RTAccountRegistrationErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"[username] is required": @(RTAccountRegistrationErrorMissingUsername),
             @"[username] must be 2-15 alphanumeric characters long": @(RTAccountRegistrationErrorInvalidUsername),
             @"[username] is not available": @(RTAccountRegistrationErrorUsernameIsUnavailable),
             
             @"[password] is required": @(RTAccountRegistrationErrorMissingPassword),
             @"[password] must be at least 6 characters long": @(RTAccountRegistrationErrorInvalidPassword),
             
             @"[email] is required": @(RTAccountRegistrationErrorMissingEmail),
             @"[email] is not a valid e-mail address": @(RTAccountRegistrationErrorInvalidEmail),
             @"[email] is not available": @(RTAccountRegistrationErrorEmailIsUnavailable),
             
             @"[display_name] is required": @(RTAccountRegistrationErrorMissingDisplayName),
             @"[display_name] must be 2-20 alphanumeric or space characters long": @(RTAccountRegistrationErrorInvalidDisplayName),
             
             @"[client_name] is required": @(RTAccountRegistrationErrorMissingClientName),
             @"Unable to register. Please try again.": @(RTAccountRegistrationErrorRegistrationServiceUnavailable)
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTAccountRegistrationErrorUnknownError;
}

@end
