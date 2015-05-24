#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RTChangePasswordViewField) {
    RTChangePasswordViewFieldPassword,
    RTChangePasswordViewFieldConfirmationPassword
};

@protocol RTChangePasswordView <NSObject>

- (void)showValidationErrorMessage:(NSString *)message
                          forField:(RTChangePasswordViewField)field;

- (void)showErrorMessage:(NSString *)message;

- (void)showMessage:(NSString *)message;

@end
