#import "RTAddVideoToReelErrorCodeToErrorMessageMapping.h"
#import "RTAddVideoToReelError.h"

@implementation RTAddVideoToReelErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTAddVideoToReelErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTAddVideoToReelErrorVideoNotFound): @"Cannot add an unknown video to a reel!",
             @(RTAddVideoToReelErrorReelNotFound): @"Cannot add a video to an unknown reel!",
             @(RTAddVideoToReelErrorUnauthorized): @"You don't have permission to do that!",
             @(RTAddVideoToReelErrorUnknownError): @"Unknown error occurred while adding the video to the reel. Please try again."
             };
}

@end
