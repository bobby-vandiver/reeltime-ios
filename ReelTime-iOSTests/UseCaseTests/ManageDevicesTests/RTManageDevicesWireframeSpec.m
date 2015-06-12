#import "RTTestCommon.h"

#import "RTManageDevicesWireframe.h"
#import "RTManageDevicesViewController.h"

#import "RTApplicationWireframe.h"

SpecBegin(RTManageDevicesWireframe)

describe(@"manage devices wireframe", ^{

    __block RTManageDevicesWireframe *wireframe;
    
    __block RTManageDevicesViewController *viewController;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        viewController = mock([RTManageDevicesViewController class]);
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        wireframe = [[RTManageDevicesWireframe alloc] initWithViewController:viewController
                                                        applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting device management", ^{
        it(@"should push view controller onto navigation controller", ^{
            [wireframe presentManageDevicesInterface];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
});

SpecEnd