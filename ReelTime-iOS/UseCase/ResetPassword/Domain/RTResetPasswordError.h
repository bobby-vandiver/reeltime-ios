#import <Foundation/Foundation.h>

extern NSString *const RTResetPasswordErrorDomain;

typedef NS_ENUM(NSInteger, RTResetPasswordError) {
    RTResetPasswordErrorMissingResetCode,
    RTResetPasswordErrorMissingUsername,
    RTResetPasswordErrorMissingPassword,
    RTResetPasswordErrorMissingConfirmationPassword,
    RTResetPasswordErrorMissingClientName,
    
    RTResetPasswordErrorInvalidPassword,
    RTResetPasswordErrorInvalidResetCode,
    
    RTResetPasswordErrorEmailFailure,

    RTResetPasswordErrorUnknownUser,
    RTResetPasswordErrorUnknownClient,
    
    RTResetPasswordErrorInvalidClientCredentials,
    RTResetPasswordErrorForbiddenClient,
    
    RTResetPasswordErrorFailedToSaveClientCredentials
};