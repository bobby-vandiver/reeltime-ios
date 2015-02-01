#import <Foundation/Foundation.h>

extern NSString *const RTLoginErrorDomain;

typedef NS_ENUM(NSInteger, RTLoginError) {
    RTLoginErrorMissingUsername,
    RTLoginErrorMissingPassword,
    RTLoginErrorUnknownClient,
    RTLoginErrorInvalidCredentials,
    RTLoginErrorUnknownTokenError,
    RTLoginErrorUnableToStoreToken,
    RTLoginErrorUnableToRemoveToken,
    RTLoginErrorUnableToSetCurrentlyLoggedInUser
};
