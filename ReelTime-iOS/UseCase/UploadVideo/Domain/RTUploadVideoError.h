#import <Foundation/Foundation.h>

extern NSString *const RTUploadVideoErrorDomain;

typedef NS_ENUM(NSInteger, RTUploadVideoError) {
    RTUploadVideoErrorMissingReelName,
    RTUploadVideoErrorMissingThumbnail,
    RTUploadVideoErrorMissingVideo,
    RTUploadVideoErrorMissingVideoTitle,
    
    RTUploadVideoErrorInvalidReelName,
    RTUploadVideoErrorInvalidThumbnail,
    RTUploadVideoErrorInvalidVideo,
    RTUploadVideoErrorInvalidVideoTitle,

    RTUploadVideoErrorUnknownReel,
    RTUploadVideoErrorServiceUnavailable,

    RTUploadVideoErrorUnknownError
};