#import <Foundation/Foundation.h>

extern NSString *const RTDeleteVideoErrorDomain;

// TODO: Add unauthorized when server is fixed to only allow the video owner delete access!
typedef NS_ENUM(NSInteger, RTDeleteVideoError) {
    RTDeleteVideoErrorVideoNotFound,
    RTDeleteVideoErrorUnknownError
};
