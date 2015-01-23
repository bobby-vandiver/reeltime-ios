#import <Foundation/Foundation.h>
#import "RTOAuth2TokenError.h"

extern NSString *const RTClientTokenErrorDomain;

typedef NS_ENUM(NSInteger, RTClientTokenErrors) {
    InvalidClientCredentials,
    InvalidUserCredentials,
    UnknownTokenError
};