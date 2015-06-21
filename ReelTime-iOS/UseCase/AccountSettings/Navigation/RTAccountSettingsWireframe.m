#import "RTAccountSettingsWireframe.h"
#import "RTAccountSettingsViewController.h"

#import "RTChangeDisplayNameWireframe.h"
#import "RTChangePasswordWireframe.h"
#import "RTConfirmAccountWireframe.h"
#import "RTManageDevicesWireframe.h"

@interface RTAccountSettingsWireframe ()

@property RTAccountSettingsViewController *viewController;

@property RTChangeDisplayNameWireframe *changeDisplayNameWireframe;
@property RTChangePasswordWireframe *changePasswordWireframe;
@property RTConfirmAccountWireframe *confirmAccountWireframe;
@property RTManageDevicesWireframe *manageDevicesWireframe;

@end

@implementation RTAccountSettingsWireframe

- (instancetype)initWithViewController:(RTAccountSettingsViewController *)viewController
            changeDisplayNameWireframe:(RTChangeDisplayNameWireframe *)changeDisplayNameWireframe
               changePasswordWireframe:(RTChangePasswordWireframe *)changePasswordWireframe
               confirmAccountWireframe:(RTConfirmAccountWireframe *)confirmAccountWireframe
                manageDevicesWireframe:(RTManageDevicesWireframe *)manageDevicesWireframe {
    self = [super init];
    if (self) {
        self.viewController = viewController;
        self.changeDisplayNameWireframe = changeDisplayNameWireframe;
        self.changePasswordWireframe = changePasswordWireframe;
        self.confirmAccountWireframe = confirmAccountWireframe;
        self.manageDevicesWireframe = manageDevicesWireframe;
    }
    return self;
}

- (void)presentAccountSettingsInterface {
    
}

- (void)presentChangeDisplayNameInterface {
    
}

- (void)presentChangePasswordInterface {
    
}

- (void)presentConfirmAccountInterface {
    
}

- (void)presentManageDevicesInterface {
    
}

@end
