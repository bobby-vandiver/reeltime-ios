#import "RTTestCommon.h"

#import "RTManageDevicesWireframe.h"
#import "RTManageDevicesViewController.h"

#import "RTLoginWireframe.h"
#import "RTApplicationWireframe.h"

SpecBegin(RTManageDevicesWireframe)

describe(@"manage devices wireframe", ^{

    __block RTManageDevicesWireframe *wireframe;
    __block RTManageDevicesViewController *viewController;
    
    __block RTLoginWireframe *loginWireframe;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTManageDevicesViewController class]);
        
        loginWireframe = mock([RTLoginWireframe class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTManageDevicesWireframe alloc] initWithViewController:viewController
                                                              loginWireframe:loginWireframe
                                                        applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting device management", ^{
        it(@"should push view controller onto navigation controller", ^{
            [wireframe presentManageDevicesInterface];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
    
    describe(@"presenting login interface", ^{
        it(@"should delegate to login interface", ^{
            [wireframe presentLoginInterface];
            [verify(loginWireframe) presentLoginInterface];
        });
    });
});

SpecEnd