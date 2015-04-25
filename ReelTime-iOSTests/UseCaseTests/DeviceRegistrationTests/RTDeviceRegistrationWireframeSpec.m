#import "RTTestCommon.h"

#import "RTDeviceRegistrationWireframe.h"
#import "RTDeviceRegistrationViewController.h"

#import "RTLoginWireframe.h"
#import "RTApplicationWireframe.h"

SpecBegin(RTDeviceRegistrationWireframe)

describe(@"device registration wireframe", ^{
    
    __block RTDeviceRegistrationWireframe *wireframe;
    __block RTDeviceRegistrationViewController *viewController;
    
    __block RTLoginWireframe *loginWireframe;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        applicationWireframe = mock([RTApplicationWireframe class]);
        loginWireframe = mock([RTLoginWireframe class]);
        
        viewController = mock([RTDeviceRegistrationViewController class]);
        wireframe = [[RTDeviceRegistrationWireframe alloc] initWithViewController:viewController
                                                                   loginWireframe:loginWireframe
                                                             applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting device registration", ^{
        it(@"should instruct application to navigate to view controller", ^{
            [wireframe presentDeviceRegistrationInterface];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
    
    describe(@"presenting login interface", ^{
        it(@"should notify the login wireframe to perform the routing", ^{
            [wireframe presentLoginInterface];
            [verify(loginWireframe) presentLoginInterface];
        });
    });
});

SpecEnd