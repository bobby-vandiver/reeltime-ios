#import "RTApplicationAwareWireframe.h"

@class RTAccountSettingsViewController;

@class RTChangeDisplayNameWireframe;
@class RTChangePasswordWireframe;
@class RTConfirmAccountWireframe;
@class RTManageDevicesWireframe;

@interface RTAccountSettingsWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTAccountSettingsViewController *)viewController
            changeDisplayNameWireframe:(RTChangeDisplayNameWireframe *)changeDisplayNameWireframe
               changePasswordWireframe:(RTChangePasswordWireframe *)changePasswordWireframe
               confirmAccountWireframe:(RTConfirmAccountWireframe *)confirmAccountWireframe
                manageDevicesWireframe:(RTManageDevicesWireframe *)manageDevicesWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentAccountSettingsInterface;

- (void)presentChangeDisplayNameInterface;

- (void)presentChangePasswordInterface;

- (void)presentConfirmAccountInterface;

- (void)presentManageDevicesInterface;

@end
