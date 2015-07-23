#import <Foundation/Foundation.h>

extern NSString *const RTFollowUserErrorDomain;

typedef NS_ENUM(NSInteger, RTFollowUserError) {
    RTFollowUserErrorUserNotFound,
    RTFollowUserErrorUnknownError
};
