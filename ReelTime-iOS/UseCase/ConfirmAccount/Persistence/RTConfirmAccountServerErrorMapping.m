#import "RTConfirmAccountServerErrorMapping.h"
#import "RTConfirmAccountError.h"

@implementation RTConfirmAccountServerErrorMapping

- (NSString *)errorDomain {
    return RTConfirmAccountErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"[code] is required": @(RTConfirmAccountErrorMissingConfirmationCode),
             @"[code] is invalid": @(RTConfirmAccountErrorInvalidConfirmationCode),
             @"Unable to send account confirmation email. Please try again.": @(RTConfirmAccountErrorEmailFailure)
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTConfirmAccountErrorUnknownError;
}

@end
