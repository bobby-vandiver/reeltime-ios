#import "RTUploadVideoServerErrorMapping.h"
#import "RTUploadVideoError.h"

@implementation RTUploadVideoServerErrorMapping

- (NSString *)errorDomain {
    return RTUploadVideoErrorDomain;
}

- (NSDictionary *)errorMessageToErrorCodeMapping {
    return @{
             @"Unable to create video. Please try again.": @(RTUploadVideoErrorServiceUnavailable),
             @"Unable to analyze video. Please try again.": @(RTUploadVideoErrorServiceUnavailable),

             @"[title] is required": @(RTUploadVideoErrorMissingVideoTitle),
             @"[title] is invalid": @(RTUploadVideoErrorInvalidVideoTitle),
             
             @"[reel] is required": @(RTUploadVideoErrorMissingReelName),
             @"[reel] is invalid": @(RTUploadVideoErrorInvalidReelName),
             @"[reel] is unknown": @(RTUploadVideoErrorUnknownReel),
             
             @"[thumbnail] is required": @(RTUploadVideoErrorMissingThumbnail),
             
             @"[thumbnail] must be png format": @(RTUploadVideoErrorInvalidThumbnail),
             @"[thumbnail] format is invalid": @(RTUploadVideoErrorInvalidThumbnail),

             @"[thumbnail] exceeds max size": @(RTUploadVideoErrorInvalidThumbnail),
             @"[thumbnail] size is invalid": @(RTUploadVideoErrorInvalidThumbnail),

             @"[video] is required": @(RTUploadVideoErrorMissingVideo),

             @"[video] must contain an h264 video stream": @(RTUploadVideoErrorInvalidVideo),
             @"Problem occurred while processing h264 video stream": @(RTUploadVideoErrorInvalidVideo),
             
             @"[video] must contain an aac audio stream": @(RTUploadVideoErrorInvalidVideo),
             @"Problem occurred while processing aac audio stream": @(RTUploadVideoErrorInvalidVideo),
             
             @"[video] exceeds max length of 2 minutes": @(RTUploadVideoErrorInvalidVideo),
             @"[video] duration is invalid": @(RTUploadVideoErrorInvalidVideo),

             @"[video] exceeds max size": @(RTUploadVideoErrorInvalidVideo),
             @"[video] size is invalid": @(RTUploadVideoErrorInvalidVideo)
             };
}

- (NSInteger)errorCodeForUnknownError {
    return RTUploadVideoErrorUnknownError;
}

@end
