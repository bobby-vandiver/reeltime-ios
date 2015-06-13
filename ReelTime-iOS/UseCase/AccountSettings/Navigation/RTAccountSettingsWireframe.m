#import "RTAccountSettingsWireframe.h"

#import "RTChangeDisplayNameWireframe.h"
#import "RTChangePasswordWireframe.h"
#import "RTManageDevicesWireframe.h"

@interface RTAccountSettingsWireframe ()

@property RTChangeDisplayNameWireframe *changeDisplayNameWireframe;
@property RTChangePasswordWireframe *changePasswordWireframe;
@property RTManageDevicesWireframe *manageDevicesWireframe;

@end

@implementation RTAccountSettingsWireframe

- (instancetype)initWithChangeDisplayNameWireframe:(RTChangeDisplayNameWireframe *)changeDisplayNameWireframe
                           changePasswordWireframe:(RTChangePasswordWireframe *)changePasswordWireframe
                            manageDevicesWireframe:(RTManageDevicesWireframe *)manageDevicesWireframe {
    self = [super init];
    if (self) {
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
