#import <Foundation/Foundation.h>

extern NSString *const RTLogoutErrorDomain;

typedef NS_ENUM(NSInteger, RTLogoutError) {
    RTLogoutErrorCurrentUsernameNotFound,
    RTLogoutErrorMissingAccessToken
};
