#import <Foundation/Foundation.h>

extern NSString *const RTLoginErrorDomain;

typedef NS_ENUM(NSInteger, RTLoginErrors) {
    LoginMissingUsername,
    LoginMissingPassword,
    LoginUnknownClient,
    LoginInvalidCredentials,
    LoginUnknownTokenError,
    LoginUnableToStoreToken,
    LoginUnableToRemoveToken,
    LoginUnableToSetCurrentlyLoggedInUser
};
