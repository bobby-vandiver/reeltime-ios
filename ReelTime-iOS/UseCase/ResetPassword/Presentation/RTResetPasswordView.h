#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RTResetPasswordViewField) {
    RTResetPasswordViewFieldResetCode,
    RTResetPasswordViewFieldUsername,
    RTResetPasswordViewFieldPassword,
    RTResetPasswordViewFieldConfirmationPassword,
    RTResetPasswordViewFieldClientName
};

@protocol RTResetPasswordView <NSObject>

- (void)showValidationErrorMessage:(NSString *)message
                          forField:(RTResetPasswordViewField)field;

- (void)showErrorMessage:(NSString *)message;

@end
