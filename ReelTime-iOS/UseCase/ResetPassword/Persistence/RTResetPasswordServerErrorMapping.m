#import "RTResetPasswordServerErrorMapping.h"
#import "RTResetPasswordError.h"

@implementation RTResetPasswordServerErrorMapping

- (NSString *)errorDomain {
    return RTResetPasswordErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"[username] is required": @(RTResetPasswordErrorMissingUsername),
             
             @"[new_password] is required": @(RTResetPasswordErrorMissingNewPassword),
             @"[new_password] must be at least 6 characters long": @(RTResetPasswordErrorInvalidNewPassword),
             
             @"[code] is required": @(RTResetPasswordErrorMissingResetCode),
             @"[code] is invalid": @(RTResetPasswordErrorInvalidResetCode),
             
             @"[client_name] is required": @(RTResetPasswordErrorMissingClientName),
             
             @"Unable to send reset password email. Please try again.": @(RTResetPasswordErrorEmailFailure),
             @"Requested user was not found": @(RTResetPasswordErrorUnknownUser),
             
             @"Invalid credentials": @(RTResetPasswordErrorInvalidClientCredentials),
             @"Forbidden request": @(RTResetPasswordErrorForbiddenClient)
             };
    
}

@end
