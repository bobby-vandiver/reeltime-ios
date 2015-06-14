#import "RTConfirmAccountErrorCodeToErrorMessageMapping.h"
#import "RTConfirmAccountError.h"

@implementation RTConfirmAccountErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTConfirmAccountErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTConfirmAccountErrorEmailFailure): @"Unable to send confirmation email",
             @(RTConfirmAccountErrorMissingConfirmationCode): @"Confirmation code is required",
             @(RTConfirmAccountErrorInvalidConfirmationCode): @"Confirmation code is invalid"
             };
}

@end
