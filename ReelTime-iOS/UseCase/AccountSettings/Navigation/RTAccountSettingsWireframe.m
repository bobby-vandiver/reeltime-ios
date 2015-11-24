#import "RTAccountSettingsWireframe.h"
#import "RTAccountSettingsViewController.h"

#import "RTChangeDisplayNameWireframe.h"
#import "RTChangePasswordWireframe.h"
#import "RTConfirmAccountWireframe.h"
#import "RTManageDevicesWireframe.h"
#import "RTRemoveAccountWireframe.h"

#import "RTApplicationWireframe.h"

@interface RTAccountSettingsWireframe ()

@property RTAccountSettingsViewController *viewController;

@property RTChangeDisplayNameWireframe *changeDisplayNameWireframe;
@property RTChangePasswordWireframe *changePasswordWireframe;
@property RTConfirmAccountWireframe *confirmAccountWireframe;
@property RTManageDevicesWireframe *manageDevicesWireframe;
@property RTRemoveAccountWireframe *removeAccountWireframe;

@end

@implementation RTAccountSettingsWireframe

- (instancetype)initWithViewController:(RTAccountSettingsViewController *)viewController
            changeDisplayNameWireframe:(RTChangeDisplayNameWireframe *)changeDisplayNameWireframe
               changePasswordWireframe:(RTChangePasswordWireframe *)changePasswordWireframe
               confirmAccountWireframe:(RTConfirmAccountWireframe *)confirmAccountWireframe
                manageDevicesWireframe:(RTManageDevicesWireframe *)manageDevicesWireframe
                removeAccountWireframe:(RTRemoveAccountWireframe *)removeAccountWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
        self.changeDisplayNameWireframe = changeDisplayNameWireframe;
        self.changePasswordWireframe = changePasswordWireframe;
        self.confirmAccountWireframe = confirmAccountWireframe;
        self.manageDevicesWireframe = manageDevicesWireframe;
        self.removeAccountWireframe = removeAccountWireframe;
    }
    return self;
}

- (void)presentAccountSettingsInterface {
    [self.applicationWireframe navigateToViewController:self.viewController];
}

- (void)presentChangeDisplayNameInterface {
    [self.changeDisplayNameWireframe presentChangeDisplayNameInterface];
}

- (void)presentChangePasswordInterface {
    [self.changePasswordWireframe presentChangePasswordInterface];
}

- (void)presentConfirmAccountInterface {
    [self.confirmAccountWireframe presentConfirmAccountInterface];
}

- (void)presentManageDevicesInterface {
    [self.manageDevicesWireframe presentManageDevicesInterface];
}

- (void)presentRemoveAccountInterface {
    [self.removeAccountWireframe presentRemoveAccountInterface];
}

@end
