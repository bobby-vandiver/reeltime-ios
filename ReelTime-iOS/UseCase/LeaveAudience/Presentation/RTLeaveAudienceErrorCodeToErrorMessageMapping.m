#import "RTLeaveAudienceErrorCodeToErrorMessageMapping.h"
#import "RTLeaveAudienceError.h"

@implementation RTLeaveAudienceErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTLeaveAudienceErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTLeaveAudienceErrorReelNotFound): @"Cannot leave audience of an unknown reel!",
             @(RTLeaveAudienceErrorUnknownError): @"Unknown error occurred while leaving audience. Please try again."
             };
}

@end
