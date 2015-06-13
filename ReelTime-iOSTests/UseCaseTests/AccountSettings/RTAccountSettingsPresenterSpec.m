#import "RTTestCommon.h"

#import "RTAccountSettingsPresenter.h"
#import "RTAccountSettingsWireframe.h"

SpecBegin(RTAccountSettingsPresenter)

describe(@"account settings presenter", ^{
    
    __block RTAccountSettingsPresenter *presenter;
    __block RTAccountSettingsWireframe *wireframe;

    beforeEach(^{
        wireframe = mock([RTAccountSettingsWireframe class]);
        presenter = [[RTAccountSettingsPresenter alloc] initWithWireframe:wireframe];
    });
    
    describe(@"requested display name change", ^{
        it(@"should route to the change display name interface", ^{
            [presenter requestedDisplayNameChange];
            [verify(wireframe) presentChangeDisplayNameInterface];
        });
    });
    
    describe(@"requested password change", ^{
        it(@"should route to the change password interface", ^{
            [presenter requestedPasswordChange];
            [verify(wireframe) presentChangePasswordInterface];
        });
    });
    
    describe(@"requested device management", ^{
        it(@"should route to the device management interface", ^{
            [presenter requestedDeviceManagement];
            [verify(wireframe) presentManageDevicesInterface];
        });
    });
});

SpecEnd