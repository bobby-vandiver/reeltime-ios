#import <Foundation/Foundation.h>

extern NSString *const RTRemoveVideoFromReelErrorDomain;

typedef NS_ENUM(NSInteger, RTRemoveVideoFromReelError) {
    RTRemoveVideoFromReelErrorVideoNotFound,
    RTRemoveVideoFromReelErrorReelNotFound,
    RTRemoveVideoFromReelErrorUnauthorized,
    RTRemoveVideoFromReelErrorUnknownError
};
