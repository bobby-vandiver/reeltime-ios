#import "RTAccountRegistrationErrorCodeToErrorMessageMapping.h"
#import "RTAccountRegistrationError.h"

@implementation RTAccountRegistrationErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTAccountRegistrationErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTAccountRegistrationErrorMissingUsername): @"Username is required",
             @(RTAccountRegistrationErrorInvalidUsername): @"Username must be 2-15 alphanumeric characters",
             @(RTAccountRegistrationErrorUsernameIsUnavailable): @"Username is unavailable",
             
             @(RTAccountRegistrationErrorMissingPassword): @"Password is required",
             @(RTAccountRegistrationErrorInvalidPassword): @"Password must be at least 6 characters",
             
             @(RTAccountRegistrationErrorMissingConfirmationPassword): @"Confirmation password is required",
             @(RTAccountRegistrationErrorConfirmationPasswordDoesNotMatch): @"Password and confirmation password must match",
             
             @(RTAccountRegistrationErrorMissingEmail): @"Email is required",
             @(RTAccountRegistrationErrorInvalidEmail): @"Email is not a valid email address",
             @(RTAccountRegistrationErrorEmailIsUnavailable): @"Email is unavailable",
             
             @(RTAccountRegistrationErrorMissingDisplayName): @"Display name is required",
             @(RTAccountRegistrationErrorInvalidDisplayName): @"Display name must be 2-20 alphanumeric or space characters",
             
             @(RTAccountRegistrationErrorMissingClientName): @"Client name is required",
             @(RTAccountRegistrationErrorRegistrationServiceUnavailable): @"Unable to register at this time. Please try again."
             };
}

@end
