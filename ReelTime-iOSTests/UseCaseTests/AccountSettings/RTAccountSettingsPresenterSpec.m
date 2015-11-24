#import "RTTestCommon.h"

#import "RTAccountSettingsPresenter.h"
#import "RTAccountSettingsWireframe.h"

#import "RTLogoutPresenter.h"

SpecBegin(RTAccountSettingsPresenter)

describe(@"account settings presenter", ^{
    
    __block RTAccountSettingsPresenter *presenter;
    __block RTAccountSettingsWireframe *wireframe;
    
    __block RTLogoutPresenter *logoutPresenter;

    beforeEach(^{
        wireframe = mock([RTAccountSettingsWireframe class]);
        logoutPresenter = mock([RTLogoutPresenter class]);
        
        presenter = [[RTAccountSettingsPresenter alloc] initWithWireframe:wireframe
                                                          logoutPresenter:logoutPresenter];
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
    
    describe(@"requested account confirmation", ^{
        it(@"should route to the confirm account interface", ^{
            [presenter requestedAccountConfirmation];
            [verify(wireframe) presentConfirmAccountInterface];
        });
    });
    
    describe(@"requested device management", ^{
        it(@"should route to the device management interface", ^{
            [presenter requestedDeviceManagement];
            [verify(wireframe) presentManageDevicesInterface];
        });
    });
    
    describe(@"requested account removal", ^{
        it(@"should route to the remove account interface", ^{
            [presenter requestedAccountRemoval];
            [verify(wireframe) presentRemoveAccountInterface];
        });
    });
    
    describe(@"requested logout", ^{
        it(@"should delegate to logout presenter", ^{
            [presenter requestedLogout];
            [verify(logoutPresenter) requestedLogout];
        });
    });
});

SpecEnd