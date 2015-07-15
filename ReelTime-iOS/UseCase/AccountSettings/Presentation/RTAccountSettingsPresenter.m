#import "RTAccountSettingsPresenter.h"
#import "RTAccountSettingsWireframe.h"

#import "RTLogoutPresenter.h"

@interface RTAccountSettingsPresenter ()

@property RTAccountSettingsWireframe *wireframe;
@property RTLogoutPresenter *logoutPresenter;

@end

@implementation RTAccountSettingsPresenter

- (instancetype)initWithWireframe:(RTAccountSettingsWireframe *)wireframe
                  logoutPresenter:(RTLogoutPresenter *)logoutPresenter {
    self = [super init];
    if (self) {
        self.wireframe = wireframe;
        self.logoutPresenter = logoutPresenter;
    }
    return self;
}

- (void)requestedDisplayNameChange {
    [self.wireframe presentChangeDisplayNameInterface];
}

- (void)requestedPasswordChange {
    [self.wireframe presentChangePasswordInterface];
}

- (void)requestedAccountConfirmation {
    [self.wireframe presentConfirmAccountInterface];
}

- (void)requestedDeviceManagement {
    [self.wireframe presentManageDevicesInterface];
}

- (void)requestedLogout {
    [self.logoutPresenter requestedLogout];
}

@end
