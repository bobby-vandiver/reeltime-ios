#import <Foundation/Foundation.h>

extern NSString *const RTLoginErrorDomain;

typedef NS_ENUM(NSInteger, RTLoginErrors) {
    MissingUsername,
    MissingPassword,
    UnknownClient,
    InvalidCredentials,
    UnableToStoreToken,
    UnableToRemoveToken,
    UnableToSetCurrentlyLoggedInUser
};
