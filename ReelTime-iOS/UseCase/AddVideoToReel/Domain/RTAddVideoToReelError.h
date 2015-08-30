#import <Foundation/Foundation.h>

extern NSString *const RTAddVideoToReelErrorDomain;

typedef NS_ENUM(NSInteger, RTAddVideoToReelError) {
    RTAddVideoToReelErrorReelNotFound,
    RTAddVideoToReelErrorVideoNotFound,
    RTAddVideoToReelErrorUnauthorized,
    RTAddVideoToReelErrorUnknownError
};
