#import "RTJoinAudienceErrorCodeToErrorMessageMapping.h"
#import "RTJoinAudienceError.h"

@implementation RTJoinAudienceErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTJoinAudienceErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTJoinAudienceErrorReelNotFound): @"Cannot join audience of an unknown reel!",
             @(RTJoinAudienceErrorUnknownError): @"Unknown error occurred while joining audience. Please try again."
             };
}

@end
