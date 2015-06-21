#import <Foundation/Foundation.h>

@class RTAccountSettingsViewController;

@class RTChangeDisplayNameWireframe;
@class RTChangePasswordWireframe;
@class RTConfirmAccountWireframe;
@class RTManageDevicesWireframe;

@interface RTAccountSettingsWireframe : NSObject

- (instancetype)initWithViewController:(RTAccountSettingsViewController *)viewController
            changeDisplayNameWireframe:(RTChangeDisplayNameWireframe *)changeDisplayNameWireframe
               changePasswordWireframe:(RTChangePasswordWireframe *)changePasswordWireframe
               confirmAccountWireframe:(RTConfirmAccountWireframe *)confirmAccountWireframe
                manageDevicesWireframe:(RTManageDevicesWireframe *)manageDevicesWireframe;

- (void)presentAccountSettingsInterface;

- (void)presentChangeDisplayNameInterface;

- (void)presentChangePasswordInterface;

- (void)presentConfirmAccountInterface;

- (void)presentManageDevicesInterface;

@end
