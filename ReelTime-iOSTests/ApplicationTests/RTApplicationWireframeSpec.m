#import "RTTestCommon.h"

#import "RTApplicationWireframe.h"

#import "RTApplicationNavigationController.h"
#import "RTApplicationTabBarController.h"

#import "RTApplicationNavigationControllerFactory.h"

#import "RTApplicationWireframeContainer.h"
#import "RTLoginWireframe.h"

@interface RTApplicationWireframe (Test)

@property RTApplicationNavigationController *navigationController;
@property RTApplicationTabBarController *tabBarController;

@property UIViewController *previousRootViewController;

@end

SpecBegin(RTApplicationWireframe)

describe(@"application wireframe", ^{
    
    __block RTApplicationWireframe *wireframe;

    __block RTApplicationNavigationController *navigationController;
    __block RTApplicationTabBarController *tabBarController;
    
    __block RTApplicationWireframeContainer *wireframeContainer;
    __block id<RTApplicationNavigationControllerFactory> navigationControllerFactory;
    
    __block RTLoginWireframe *loginWireframe;
    
    __block UIWindow *window;
    __block UIViewController *viewController;

    void (^setNavigationController)() = ^{
        wireframe.navigationController = navigationController;
    };
    
    beforeEach(^{
        window = mock([UIWindow class]);
        viewController = mock([UIViewController class]);
    
        navigationController = mock([RTApplicationNavigationController class]);
        tabBarController = mock([RTApplicationTabBarController class]);

        navigationControllerFactory = mockProtocol(@protocol(RTApplicationNavigationControllerFactory));
        
        wireframeContainer = [[RTApplicationWireframeContainer alloc] init];

        loginWireframe = mock([RTLoginWireframe class]);
        wireframeContainer.loginWireframe = loginWireframe;
        
        wireframe = [[RTApplicationWireframe alloc]initWithWindow:window
                                                  tabBarController:tabBarController
                                                wireframeContainer:wireframeContainer
                                      navigationControllerFactory:navigationControllerFactory];
    });
    
    describe(@"presenting initial screen", ^{
        it(@"should present the login interface", ^{
            [wireframe presentInitialScreen];
            [verify(loginWireframe) presentLoginInterface];
        });
    });
    
    describe(@"presenting previous screen", ^{
        afterEach(^{
            expect(wireframe.previousRootViewController).to.beNil();
        });
        
        context(@"no previous screen available", ^{
            beforeEach(^{
                wireframe.previousRootViewController = nil;
            });
            
            it(@"should do nothing", ^{
                [wireframe presentPreviousScreen];
                [verifyCount(window, never()) setRootViewController:anything()];
            });
        });
        
        context(@"previous screen available -- tab bar controller", ^{
            beforeEach(^{
                wireframe.previousRootViewController = tabBarController;
                wireframe.tabBarController = nil;

                [wireframe presentPreviousScreen];
            });
            
            it(@"should restore previous root view controller", ^{
                [verify(window) setRootViewController:tabBarController];
            });
            
            it(@"should restore tab bar controller", ^{
                expect(wireframe.tabBarController).to.equal(tabBarController);
            });
        });
        
        context(@"previous screen available -- navigation controller", ^{
            beforeEach(^{
                wireframe.previousRootViewController = navigationController;
                wireframe.navigationController = nil;
                
                [wireframe presentPreviousScreen];
            });
            
            it(@"should restore previous root view controller", ^{
                [verify(window) setRootViewController:navigationController];
            });
            
            it(@"should restore navigation controller", ^{
                expect(wireframe.navigationController).to.equal(navigationController);
            });
        });
    });
    
    describe(@"presenting tab bar managed screen", ^{
        it(@"should install tab bar view controller as the root view controller", ^{
            [wireframe presentTabBarManagedScreen];
            [verify(window) setRootViewController:tabBarController];
        });
        
        it(@"should save current root view controller as the last view controller", ^{
            [given([window rootViewController]) willReturn:viewController];
            [wireframe presentTabBarManagedScreen];
            expect(wireframe.previousRootViewController).to.equal(viewController);
        });
    });
    
    describe(@"presenting navigation root controller", ^{
        beforeEach(^{
            [given([navigationControllerFactory applicationNavigationControllerWithRootViewController:viewController]) willReturn:navigationController];
        });
        
        it(@"should create navigation view controller with the provided view controller and install it as the root view controller", ^{
            [wireframe presentNavigationRootViewController:viewController];
            [verify(window) setRootViewController:navigationController];
        });
        
        it(@"should save current root view controller as the last view controller", ^{
            [given([window rootViewController]) willReturn:viewController];
            [wireframe presentNavigationRootViewController:anything()];
            expect(wireframe.previousRootViewController).to.equal(viewController);
        });
    });

    describe(@"navigating to a view controller", ^{
        
        context(@"on tab bar managed screen", ^{
            beforeEach(^{
                [wireframe presentTabBarManagedScreen];
                [verify(window) reset];
                [given([tabBarController selectedViewController]) willReturn:navigationController];
            });
            
            it(@"should push view controller on navigation controller managed by tab bar controller", ^{
                [wireframe navigateToViewController:viewController];
                [navigationController pushViewController:viewController animated:YES];
            });
        });
        
        context(@"on non tab bar managed screen", ^{
            it(@"should push view controller on navigation controller", ^{
                [wireframe navigateToViewController:viewController];
                [navigationController pushViewController:viewController animated:YES];
            });
        });
    });
    
    describe(@"checking visible view controller", ^{
        beforeEach(^{
            setNavigationController();
        });
        
        it(@"view controller is visible", ^{
            [given([navigationController visibleViewController]) willReturn:viewController];
            expect([wireframe isVisibleViewController:viewController]).to.beTruthy();
        });
        
        it(@"view controller is not visible", ^{
            [given([navigationController visibleViewController]) willReturn:nil];
            expect([wireframe isVisibleViewController:viewController]).to.beFalsy();
        });
    });
});

SpecEnd