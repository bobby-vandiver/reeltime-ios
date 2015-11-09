#import "RTUploadVideoErrorCodeToErrorMessageMapping.h"
#import "RTUploadVideoError.h"

@implementation RTUploadVideoErrorCodeToErrorMessageMapping

- (NSString *)errorDomain {
    return RTUploadVideoErrorDomain;
}

- (NSDictionary *)errorCodeToErrorMessageMapping {
    return @{
             @(RTUploadVideoErrorMissingReelName): @"Reel name is required",
             @(RTUploadVideoErrorMissingThumbnail): @"Thumbnail is required",
             @(RTUploadVideoErrorMissingVideo): @"Video is required",
             @(RTUploadVideoErrorMissingVideoTitle): @"Video title is required",
             @(RTUploadVideoErrorInvalidReelName): @"Reel name is invalid",
             @(RTUploadVideoErrorInvalidThumbnail): @"Thumbnail is invalid",
             @(RTUploadVideoErrorInvalidVideo): @"Video is invalid",
             @(RTUploadVideoErrorInvalidVideoTitle): @"Video title is invalid",
             @(RTUploadVideoErrorUnknownReel): @"Unknown reel",
             @(RTUploadVideoErrorServiceUnavailable): @"Could not upload video at this time. Please try again.",
             @(RTUploadVideoErrorUnknownError): @"An unexpected error occurred. Please try again."
             };
}

@end
