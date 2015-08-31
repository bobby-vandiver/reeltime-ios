#import "RTAddVideoToReelServerErrorMapping.h"
#import "RTAddVideoToReelError.h"

@implementation RTAddVideoToReelServerErrorMapping

- (NSString *)errorDomain {
    return RTAddVideoToReelErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"Requested video was not found": @(RTAddVideoToReelErrorVideoNotFound),
             @"Requested reel was not found": @(RTAddVideoToReelErrorReelNotFound),
             @"Unauthorized operation requested": @(RTAddVideoToReelErrorUnauthorized)
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTAddVideoToReelErrorUnknownError;
}

@end
