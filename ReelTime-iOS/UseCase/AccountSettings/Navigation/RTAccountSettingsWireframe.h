#import "RTApplicationAwareWireframe.h"

@class RTAccountSettingsViewController;

@class RTChangeDisplayNameWireframe;
@class RTChangePasswordWireframe;
@class RTConfirmAccountWireframe;
@class RTManageDevicesWireframe;
@class RTRemoveAccountWireframe;

@interface RTAccountSettingsWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTAccountSettingsViewController *)viewController
            changeDisplayNameWireframe:(RTChangeDisplayNameWireframe *)changeDisplayNameWireframe
               changePasswordWireframe:(RTChangePasswordWireframe *)changePasswordWireframe
               confirmAccountWireframe:(RTConfirmAccountWireframe *)confirmAccountWireframe
                manageDevicesWireframe:(RTManageDevicesWireframe *)manageDevicesWireframe
                removeAccountWireframe:(RTRemoveAccountWireframe *)removeAccountWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentAccountSettingsInterface;

- (void)presentChangeDisplayNameInterface;

- (void)presentChangePasswordInterface;

- (void)presentConfirmAccountInterface;

- (void)presentManageDevicesInterface;

- (void)presentRemoveAccountInterface;

@end
