#import <Foundation/Foundation.h>

extern NSString *const RTDeleteVideoErrorDomain;

typedef NS_ENUM(NSInteger, RTDeleteVideoError) {
    RTDeleteVideoErrorVideoNotFound,
    RTDeleteVideoErrorUnknownError
};
