#import "RTTestCommon.h"

#import "RTAccountSettingsWireframe.h"
#import "RTAccountSettingsViewController.h"

#import "RTChangeDisplayNameWireframe.h"
#import "RTChangePasswordWireframe.h"

#import "RTConfirmAccountWireframe.h"
#import "RTManageDevicesWireframe.h"

#import "RTRemoveAccountWireframe.h"
#import "RTApplicationWireframe.h"

SpecBegin(RTAccountSettingsWireframe)

describe(@"account settings wireframe", ^{
    
    __block RTAccountSettingsWireframe *wireframe;
    __block RTAccountSettingsViewController *viewController;
    
    __block RTChangeDisplayNameWireframe *changeDisplayNameWireframe;
    __block RTChangePasswordWireframe *changePasswordWireframe;

    __block RTConfirmAccountWireframe *confirmAccountWireframe;
    __block RTManageDevicesWireframe *manageDevicesWireframe;
    
    __block RTRemoveAccountWireframe *removeAccountWireframe;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTAccountSettingsViewController class]);
         
        changeDisplayNameWireframe = mock([RTChangeDisplayNameWireframe class]);
        changePasswordWireframe = mock([RTChangePasswordWireframe class]);
        
        confirmAccountWireframe = mock([RTConfirmAccountWireframe class]);
        manageDevicesWireframe = mock([RTManageDevicesWireframe class]);
        
        removeAccountWireframe = mock([RTRemoveAccountWireframe class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTAccountSettingsWireframe alloc] initWithViewController:viewController
                                                    changeDisplayNameWireframe:changeDisplayNameWireframe
                                                       changePasswordWireframe:changePasswordWireframe
                                                       confirmAccountWireframe:confirmAccountWireframe
                                                        manageDevicesWireframe:manageDevicesWireframe
                                                        removeAccountWireframe:removeAccountWireframe
                                                          applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting account settings interface", ^{
        it(@"should navigate to settings view controller", ^{
            [wireframe presentAccountSettingsInterface];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
    
    describe(@"presenting change display name interface", ^{
        it(@"should delegate to change display name wireframe", ^{
            [wireframe presentChangeDisplayNameInterface];
            [verify(changeDisplayNameWireframe) presentChangeDisplayNameInterface];
        });
    });
    
    describe(@"presenting change password interface", ^{
        it(@"should delegate to change password wireframe", ^{
            [wireframe presentChangePasswordInterface];
            [verify(changePasswordWireframe) presentChangePasswordInterface];
        });
    });
    
    describe(@"presenting account confirmation interface", ^{
        it(@"should delegate to confirm account wireframe", ^{
            [wireframe presentConfirmAccountInterface];
            [verify(confirmAccountWireframe) presentConfirmAccountInterface];
        });
    });
    
    describe(@"presenting device management interface", ^{
        it(@"should delegate to manage devices wireframe", ^{
            [wireframe presentManageDevicesInterface];
            [verify(manageDevicesWireframe) presentManageDevicesInterface];
        });
    });
    
    describe(@"presenting account removal interface", ^{
        it(@"should delegate to remove account wireframe", ^{
            [wireframe presentRemoveAccountInterface];
            [verify(removeAccountWireframe) presentRemoveAccountInterface];
        });
    });
});

SpecEnd