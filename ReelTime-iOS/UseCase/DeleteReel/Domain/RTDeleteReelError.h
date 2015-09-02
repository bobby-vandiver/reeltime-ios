#import <Foundation/Foundation.h>

extern NSString *const RTDeleteReelErrorDomain;

typedef NS_ENUM(NSInteger, RTDeleteReelError) {
    RTDeleteReelErrorReelNotFound,
    RTDeleteReelErrorUnauthorized,
    RTDeleteReelErrorUnknownError
};
