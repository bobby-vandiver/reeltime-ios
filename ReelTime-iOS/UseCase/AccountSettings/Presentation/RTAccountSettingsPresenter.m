#import "RTAccountSettingsPresenter.h"
#import "RTAccountSettingsWireframe.h"

@interface RTAccountSettingsPresenter ()

@property RTAccountSettingsWireframe *wireframe;

@end

@implementation RTAccountSettingsPresenter

- (instancetype)initWithWireframe:(RTAccountSettingsWireframe *)wireframe {
    self = [super init];
    if (self) {
        self.wireframe = wireframe;
    }
    return self;
}

- (void)requestedDisplayNameChange {
    [self.wireframe presentChangeDisplayNameInterface];
}

- (void)requestedPasswordChange {
    [self.wireframe presentChangePasswordInterface];
}

- (void)requestedDeviceManagement {
    [self.wireframe presentManageDevicesInterface];
}

@end
