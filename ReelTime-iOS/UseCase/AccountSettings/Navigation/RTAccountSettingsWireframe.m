#import "RTAccountSettingsWireframe.h"
#import "RTAccountSettingsViewController.h"

#import "RTChangeDisplayNameWireframe.h"
#import "RTChangePasswordWireframe.h"
#import "RTManageDevicesWireframe.h"

@interface RTAccountSettingsWireframe ()

@property RTAccountSettingsViewController *viewController;

@property RTChangeDisplayNameWireframe *changeDisplayNameWireframe;
@property RTChangePasswordWireframe *changePasswordWireframe;
@property RTManageDevicesWireframe *manageDevicesWireframe;

@end

@implementation RTAccountSettingsWireframe

- (instancetype)initWithViewController:(RTAccountSettingsViewController *)viewController
            changeDisplayNameWireframe:(RTChangeDisplayNameWireframe *)changeDisplayNameWireframe
               changePasswordWireframe:(RTChangePasswordWireframe *)changePasswordWireframe
                manageDevicesWireframe:(RTManageDevicesWireframe *)manageDevicesWireframe {
    self = [super init];
    if (self) {
        self.viewController = viewController;
        self.changeDisplayNameWireframe = changeDisplayNameWireframe;
        self.changePasswordWireframe = changePasswordWireframe;
        self.manageDevicesWireframe = manageDevicesWireframe;
    }
    return self;
}

- (void)presentChangeDisplayNameInterface {
    
}

- (void)presentChangePasswordInterface {
    
}

- (void)presentManageDevicesInterface {
    
}

@end
