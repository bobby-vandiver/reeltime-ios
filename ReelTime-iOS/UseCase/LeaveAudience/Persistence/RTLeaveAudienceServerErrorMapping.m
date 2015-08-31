#import "RTLeaveAudienceServerErrorMapping.h"
#import "RTLeaveAudienceError.h"

@implementation RTLeaveAudienceServerErrorMapping

- (NSString *)errorDomain {
    return RTLeaveAudienceErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"Requested reel was not found": @(RTLeaveAudienceErrorReelNotFound)
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTLeaveAudienceErrorUnknownError;
}

@end
