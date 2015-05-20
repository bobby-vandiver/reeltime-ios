#import <Foundation/Foundation.h>

extern NSString *const RTChangePasswordErrorDomain;

typedef NS_ENUM(NSInteger, RTChangePasswordError) {
    RTChangePasswordErrorMissingPassword,
    RTChangePasswordErrorMissingConfirmationPassword,
    RTChangePasswordErrorConfirmationPasswordDoesNotMatch
};