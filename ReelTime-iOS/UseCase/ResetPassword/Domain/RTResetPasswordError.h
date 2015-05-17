#import <Foundation/Foundation.h>

extern NSString *const RTResetPasswordErrorDomain;

typedef NS_ENUM(NSInteger, RTResetPasswordError) {
    RTResetPasswordErrorMissingUsername,
    RTResetPasswordErrorMissingNewPassword,
    RTResetPasswordErrorMissingResetCode,
    RTResetPasswordErrorMissingClientName,
    
    RTResetPasswordErrorInvalidNewPassword,
    RTResetPasswordErrorInvalidResetCode,
    
    RTResetPasswordErrorEmailFailure,

    RTResetPasswordErrorUnknownUser,
    RTResetPasswordErrorUnknownClient,
    
    RTResetPasswordErrorInvalidClientCredentials,
    RTResetPasswordErrorForbiddenClient
};