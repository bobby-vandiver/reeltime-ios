#import "RTTestCommon.h"

#import "RTResetPasswordWireframe.h"
#import "RTResetPasswordViewController.h"

#import "RTLoginWireframe.h"
#import "RTApplicationWireframe.h"

SpecBegin(RTResetPasswordWireframe)

describe(@"reset password wireframe", ^{
    
    __block RTResetPasswordWireframe *wireframe;
    __block RTResetPasswordViewController *viewController;
    
    __block RTLoginWireframe *loginWireframe;
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        applicationWireframe = mock([RTApplicationWireframe class]);
        loginWireframe = mock([RTLoginWireframe class]);
        
        viewController = mock([RTResetPasswordViewController class]);
        wireframe = [[RTResetPasswordWireframe alloc] initWithViewController:viewController
                                                              loginWireframe:loginWireframe
                                                        applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting reset password email interface", ^{
        it(@"should instruct application to navigate to view controller", ^{
            [wireframe presentResetPasswordEmailInterface];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
    });
    
    describe(@"presenting reset password interface", ^{
        it(@"should instruct application to navigate to view controller", ^{
            [given([applicationWireframe isVisibleViewController:viewController]) willReturnBool:NO];
            [wireframe presentResetPasswordInterface];
            [verify(applicationWireframe) navigateToViewController:viewController];
        });
        
        it(@"should skip navigation if the view controller is already on the screen", ^{
            [given([applicationWireframe isVisibleViewController:viewController]) willReturnBool:YES];
            [wireframe presentResetPasswordInterface];
            [verifyCount(applicationWireframe, never()) navigateToViewController:anything()];
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