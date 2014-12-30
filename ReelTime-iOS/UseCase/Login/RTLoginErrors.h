#import <Foundation/Foundation.h>

extern NSString *const RTLoginErrorsDomain;

typedef NS_ENUM(NSInteger, RTLoginErrors) {
    UnknownClient,
    InvalidCredentials
};
