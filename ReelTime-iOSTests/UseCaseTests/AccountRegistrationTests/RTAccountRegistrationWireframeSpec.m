#import "RTTestCommon.h"

#import "RTAccountRegistrationWireframe.h"
#import "RTAccountRegistrationViewController.h"

#import "RTLoginWireframe.h"
#import "RTDeviceRegistrationWireframe.h"
#import "RTApplicationWireframe.h"

SpecBegin(RTAccountRegistrationWireframe)

describe(@"account registration wireframe", ^{
    
    __block RTAccountRegistrationWireframe *wireframe;
    __block RTAccountRegistrationViewController *viewController;
    
    __block RTLoginWireframe *loginWireframe;
    __block RTDeviceRegistrationWireframe *deviceRegistrationWireframe;
    
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        deviceRegistrationWireframe = mock([RTDeviceRegistrationWireframe class]);
        loginWireframe = mock([RTLoginWireframe class]);
        
        viewController = mock([RTAccountRegistrationViewController class]);
        wireframe = [[RTAccountRegistrationWireframe alloc] initWithViewController:viewController
                                                                    loginWireframe:loginWireframe
                                                       deviceRegistrationWireframe:deviceRegistrationWireframe
                                                              applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting account registration", ^{
        it(@"should instruct application to navigate to the view controller", ^{
            [wireframe presentAccountRegistrationInterface];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
    
    describe(@"presenting login", ^{
        it(@"should delegate to the login wireframe", ^{
            [wireframe presentLoginInterface];
            [verify(loginWireframe) presentLoginInterface];
        });
    });
    
    describe(@"presenting post auto-login", ^{
        it(@"should delegate to the login wireframe", ^{
            [wireframe presentPostAutoLoginInterface];
            [verify(loginWireframe) presentPostLoginInterface];
        });
    });
    
    describe(@"presenting device registration", ^{
        it(@"should delegate to the device registration wireframe", ^{
            [wireframe presentDeviceRegistrationInterface];
            [verify(deviceRegistrationWireframe) presentDeviceRegistrationInterface];
        });
    });
});

SpecEnd