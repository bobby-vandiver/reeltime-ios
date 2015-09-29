#import "RTTestCommon.h"

#import "RTLoginWireframe.h"
#import "RTLoginViewController.h"

#import "RTAccountRegistrationWireframe.h"
#import "RTDeviceRegistrationWireframe.h"
#import "RTResetPasswordWireframe.h"

#import "RTApplicationWireframe.h"

SpecBegin(RTLoginWireframe)

describe(@"login wireframe", ^{
    
    __block RTLoginWireframe *wireframe;
    __block RTLoginViewController *viewController;
    
    __block RTAccountRegistrationWireframe *accountRegistrationWireframe;
    __block RTDeviceRegistrationWireframe *deviceRegistrationWireframe;
    __block RTResetPasswordWireframe *resetPasswordWireframe;
    
    __block RTApplicationWireframe *applicationWireframe;
    
    beforeEach(^{
        applicationWireframe = mock([RTApplicationWireframe class]);
        
        resetPasswordWireframe = mock([RTResetPasswordWireframe class]);
        deviceRegistrationWireframe = mock([RTDeviceRegistrationWireframe class]);
        accountRegistrationWireframe = mock([RTAccountRegistrationWireframe class]);
        
        viewController = mock([RTLoginViewController class]);
        wireframe = [[RTLoginWireframe alloc] initWithViewController:viewController
                                        accountRegistrationWireframe:accountRegistrationWireframe
                                         deviceRegistrationWireframe:deviceRegistrationWireframe
                                              resetPasswordWireframe:resetPasswordWireframe
                                                applicationWireframe:applicationWireframe];
    });
    
    describe(@"presenting login", ^{
        it(@"should install view controller as the root of the application-level navigation controller", ^{
            [wireframe presentLoginInterface];
            [verify(applicationWireframe) presentNavigationRootViewController:viewController];
        });
    });
    
    describe(@"presenting relogin", ^{
        it(@"should do the same as the login interface and install view controller as root of application-level navigation controller", ^{
            [wireframe presentReloginInterface];
            [verify(applicationWireframe) presentNavigationRootViewController:viewController];
        });
    });
    
    describe(@"presenting post login interface", ^{
        
        context(@"when login was requested", ^{
            beforeEach(^{
                [wireframe presentLoginInterface];
                [verify(applicationWireframe) reset];
            });
            
            it(@"should present tab bar managed screen", ^{
                [wireframe presentPostLoginInterface];
                [verify(applicationWireframe) presentTabBarManagedScreen];
            });
        });
        
        context(@"when relogin was requested", ^{
            beforeEach(^{
                [wireframe presentReloginInterface];
                [verify(applicationWireframe) reset];
            });
            
            it(@"should present previous screen", ^{
                [wireframe presentPostLoginInterface];
                [verify(applicationWireframe) presentPreviousScreen];
            });
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
    
    describe(@"presenting reset password", ^{
        it(@"should delegate to reset password wireframe", ^{
            [wireframe presentResetPasswordInterface];
            [verify(resetPasswordWireframe) presentResetPasswordEmailInterface];
        });
    });
});

SpecEnd