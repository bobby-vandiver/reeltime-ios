#import "RTTestCommon.h"

#import "RTLoginWireframe.h"
#import "RTLoginViewController.h"

#import "RTAccountRegistrationWireframe.h"
#import "RTDeviceRegistrationWireframe.h"

#import "RTApplicationWireframe.h"

SpecBegin(RTLoginWireframe)

describe(@"login wireframe", ^{
    
    __block RTLoginWireframe *wireframe;
    __block RTLoginViewController *viewController;
    
    __block RTAccountRegistrationWireframe *accountRegistrationWireframe;
    __block RTDeviceRegistrationWireframe *deviceRegistrationWireframe;
    
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        deviceRegistrationWireframe = mock([RTDeviceRegistrationWireframe class]);
        accountRegistrationWireframe = mock([RTAccountRegistrationWireframe class]);
        
        viewController = mock([RTLoginViewController class]);
        wireframe = [[RTLoginWireframe alloc] initWithViewController:viewController
                                        accountRegistrationWireframe:accountRegistrationWireframe
                                         deviceRegistrationWireframe:deviceRegistrationWireframe
                                                applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting login", ^{
        it(@"should install view controller as the root of the application-level navigation contoller", ^{
            [wireframe presentLoginInterface];
            [verify(applicationWireframe) presentNavigationRootViewController:viewController];
        });
    });
    
    describe(@"presenting device registration", ^{
        it(@"should delegate to device registration wireframe", ^{
            [wireframe presentDeviceRegistrationInterface];
            [verify(deviceRegistrationWireframe) presentDeviceRegistrationInterface];
        });
    });
    
    describe(@"presenting account registration", ^{
        it(@"should delegate to account registration wireframe", ^{
            [wireframe presentAccountRegistrationInterface];
            [verify(accountRegistrationWireframe) presentAccountRegistrationInterface];
        });
    });
});

SpecEnd