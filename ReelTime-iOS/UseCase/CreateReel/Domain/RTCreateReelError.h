#import <Foundation/Foundation.h>

extern NSString *const RTCreateReelErrorDomain;

typedef NS_ENUM(NSInteger, RTCreateReelError) {
    RTCreateReelErrorMissingReelName,
    RTCreateReelErrorInvalidReelName,
    RTCreateReelErrorReservedReelName,
    RTCreateReelErrorReelNameIsUnavailable,
    RTCreateReelErrorUnknownError
};
