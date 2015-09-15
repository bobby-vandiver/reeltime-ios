#import "RTRemoveVideoFromReelServerErrorMapping.h"
#import "RTRemoveVideoFromReelError.h"

@implementation RTRemoveVideoFromReelServerErrorMapping

- (NSString *)errorDomain {
    return RTRemoveVideoFromReelErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"Requested video was not found": @(RTRemoveVideoFromReelErrorVideoNotFound),
             @"Requested reel was not found": @(RTRemoveVideoFromReelErrorReelNotFound),
             @"Unauthorized operation requested": @(RTRemoveVideoFromReelErrorUnauthorized)
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTRemoveVideoFromReelErrorUnknownError;
}

@end
