#import "RTUploadVideoErrorCodeToErrorMessageMapping.h"
#import "RTUploadVideoError.h"

@implementation RTUploadVideoErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTUploadVideoErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTUploadVideoErrorMissingReelName): @"Reel name is required",
             @(RTUploadVideoErrorMissingVideoTitle): @"Video title is required",
             @(RTUploadVideoErrorInvalidVideoTitle): @"Video title is invalid"
             };
}

@end
