#import <Foundation/Foundation.h>

extern NSString *const RTUnfollowUserErrorDomain;

typedef NS_ENUM(NSInteger, RTUnfollowUserError) {
    RTUnfollowUserErrorUserNotFound,
    RTUnfollowUserErrorUnknownError
};
