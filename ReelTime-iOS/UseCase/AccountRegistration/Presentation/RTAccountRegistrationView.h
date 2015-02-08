#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RTAccountRegistrationViewField) {
    RTAccountRegistrationViewFieldUsername,
    RTAccountRegistrationViewFieldPassword,
    RTAccountRegistrationViewFieldConfirmationPassword,
    RTAccountRegistrationViewFieldEmail,
    RTAccountRegistrationViewFieldDisplayName,
    RTAccountRegistrationViewFieldClientName
};

@protocol RTAccountRegistrationView <NSObject>

- (void)showValidationErrorMessage:(NSString *)message
                          forField:(RTAccountRegistrationViewField)field;

- (void)showErrorMessage:(NSString *)message;

@end
