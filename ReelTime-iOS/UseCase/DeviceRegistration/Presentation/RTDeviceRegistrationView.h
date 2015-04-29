#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RTDeviceRegistrationViewField) {
    RTDeviceRegistrationViewFieldUsername,
    RTDeviceRegistrationViewFieldPassword,
    RTDeviceRegistrationViewFieldClientName
};

@protocol RTDeviceRegistrationView <NSObject>

- (void)showValidationErrorMessage:(NSString *)message
                          forField:(RTDeviceRegistrationViewField)field;

- (void)showErrorMessage:(NSString *)message;

@end
