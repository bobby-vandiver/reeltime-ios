#import <Foundation/Foundation.h>

extern NSString *const RTResetPasswordErrorDomain;

typedef NS_ENUM(NSInteger, RTResetPasswordError) {
    RTResetPasswordErrorMissingResetCode,
    RTResetPasswordErrorMissingUsername,
    RTResetPasswordErrorMissingPassword,
    RTResetPasswordErrorMissingConfirmationPassword,
    RTResetPasswordErrorMissingClientName,
    
    RTResetPasswordErrorInvalidResetCode,
    RTResetPasswordErrorInvalidPassword,
    
    RTResetPasswordErrorEmailFailure,
    RTResetPasswordErrorConfirmationPasswordDoesNotMatch,

    RTResetPasswordErrorUnknownUser,
    RTResetPasswordErrorUnknownClient,
    
    RTResetPasswordErrorInvalidClientCredentials,
    RTResetPasswordErrorForbiddenClient,
    
    RTResetPasswordErrorFailedToSaveClientCredentials
};