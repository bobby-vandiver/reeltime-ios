#import <Foundation/Foundation.h>

extern NSString *const RTResetPasswordErrorDomain;

typedef NS_ENUM(NSInteger, RTResetPasswordError) {
    RTResetPasswordErrorMissingUsername,
    RTResetPasswordErrorMissingNewPassword,
    RTResetPasswordErrorMissingResetCode,
    RTResetPasswordErrorMissingClientName,
    
    RTResetPasswordErrorInvalidUsername,
    RTResetPasswordErrorInvalidNewPassword,
    RTResetPasswordErrorInvalidResetCode,
    
    RTResetPasswordErrorEmailFailure,
    RTResetPasswordErrorInvalidClientCredentials
};