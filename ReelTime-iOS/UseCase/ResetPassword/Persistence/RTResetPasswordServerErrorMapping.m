#import "RTResetPasswordServerErrorMapping.h"
#import "RTResetPasswordError.h"

@implementation RTResetPasswordServerErrorMapping

- (NSString *)errorDomain {
    return RTResetPasswordErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"Requested user was not found": @(RTResetPasswordErrorUnknownUser),
             @"Unable to send reset password email. Please try again.": @(RTResetPasswordErrorEmailFailure)
             };
}

@end
