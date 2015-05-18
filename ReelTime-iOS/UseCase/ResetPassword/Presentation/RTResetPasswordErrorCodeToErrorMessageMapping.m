#import "RTResetPasswordErrorCodeToErrorMessageMapping.h"
#import "RTResetPasswordError.h"

@implementation RTResetPasswordErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTResetPasswordErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    NSString *invalidClient = @"We could not recognize this device. Please register a new one.";
    
    return @{
             @(RTResetPasswordErrorMissingResetCode): @"Reset code is required",
             @(RTResetPasswordErrorMissingUsername): @"Username is required",
             @(RTResetPasswordErrorMissingPassword): @"Password is required",
             @(RTResetPasswordErrorMissingConfirmationPassword): @"Confirmation password is required",
             @(RTResetPasswordErrorMissingClientName): @"Client name is required",
             @(RTResetPasswordErrorInvalidResetCode): @"Reset code is invalid",
             @(RTResetPasswordErrorInvalidPassword): @"Password must be at least 6 characters",
             @(RTResetPasswordErrorConfirmationPasswordDoesNotMatch): @"Password and confirmation password must match",
             @(RTResetPasswordErrorEmailFailure): @"We were not able to send the reset password email at this time. Try again shortly.",
             @(RTResetPasswordErrorFailedToSaveClientCredentials): @"We reset your password, but encountered a problem while registering this device. Please try again later.",
             @(RTResetPasswordErrorUnknownClient): invalidClient,
             @(RTResetPasswordErrorInvalidClientCredentials): invalidClient,
             @(RTResetPasswordErrorForbiddenClient): invalidClient
             };
}

@end
