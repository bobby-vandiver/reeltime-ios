#import "RTJoinAudienceServerErrorMapping.h"
#import "RTJoinAudienceError.h"

@implementation RTJoinAudienceServerErrorMapping

- (NSString *)errorDomain {
    return RTJoinAudienceErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"Requested reel was not found": @(RTJoinAudienceErrorReelNotFound)
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTJoinAudienceErrorUnknownError;
}

@end
