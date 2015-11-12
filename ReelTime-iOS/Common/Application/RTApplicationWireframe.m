#import "RTApplicationWireframe.h"

#import "RTApplicationWindowHandle.h"
#import "RTApplicationNavigationController.h"
#import "RTApplicationTabBarController.h"
#import "RTApplicationWireframeContainer.h"
#import "RTApplicationNavigationControllerFactory.h"

#import "RTLoginWireframe.h"
#import "RTBrowseAllViewController.h"

#import "RTLogging.h"
#import "RTStringUtils.h"

@interface RTApplicationWireframe ()

@property RTApplicationWindowHandle *windowHandle;

@property RTApplicationNavigationController *navigationController;
@property RTApplicationTabBarController *tabBarController;

@property RTApplicationWireframeContainer *wireframeContainer;
@property id<RTApplicationNavigationControllerFactory> navigationControllerFactory;

@property (readonly) UIWindow *window;
@property UIViewController *previousRootViewController;

@end

@implementation RTApplicationWireframe

- (instancetype)initWithWindowHandle:(RTApplicationWindowHandle *)windowHandle
                    tabBarController:(RTApplicationTabBarController *)tabBarController
                  wireframeContainer:(RTApplicationWireframeContainer *)wireframeContainer
         navigationControllerFactory:(id<RTApplicationNavigationControllerFactory>)navigationControllerFactory {
    self = [super init];
    if (self) {
        self.windowHandle = windowHandle;
        self.tabBarController = tabBarController;
        self.wireframeContainer = wireframeContainer;
        self.navigationControllerFactory = navigationControllerFactory;
    }
    return self;
}

- (UIWindow *)window {
    return self.windowHandle.window;
}

- (void)presentInitialScreen {
    [self.wireframeContainer.loginWireframe presentLoginInterface];
}

- (void)presentPreviousScreen {
    if (self.previousRootViewController) {
        self.window.rootViewController = self.previousRootViewController;

        if ([self.previousRootViewController isKindOfClass:[RTApplicationTabBarController class]]) {
            self.tabBarController = (RTApplicationTabBarController *) self.previousRootViewController;
        }
        else if ([self.previousRootViewController isKindOfClass:[RTApplicationNavigationController class]]) {
            self.navigationController = (RTApplicationNavigationController *) self.previousRootViewController;
        }

        self.previousRootViewController = nil;
    }
}

- (void)presentTabBarManagedScreen {
    [self saveCurrentRootViewController];
    
    self.window.rootViewController = self.tabBarController;
}

- (void)presentNavigationRootViewController:(UIViewController *)viewController {
    [self saveCurrentRootViewController];

    self.navigationController = [self.navigationControllerFactory applicationNavigationControllerWithRootViewController:viewController];
    self.window.rootViewController = self.navigationController;
}

- (void)saveCurrentRootViewController {
    self.previousRootViewController = self.window.rootViewController;
}

// TODO: Need to *always* retrieve navigationController and tabBarController via self.window
- (void)navigateToViewController:(UIViewController *)viewController {
    BOOL onTabBarManagedScreen = [self.window.rootViewController isKindOfClass:[UITabBarController class]];

//        DDLogDebug(@"navigating to view controller = %@, on tab bar managed screen = %@", viewController, stringForBool(onTabBarManagedScreen));
    
    if (onTabBarManagedScreen) {
        UITabBarController *tabBarController = (UITabBarController *) self.window.rootViewController;
        DDLogDebug(@"tabBarController = %@, self.tabBarController = %@", tabBarController, self.tabBarController);

//            UINavigationController *tabNavController = (UINavigationController *) self.tabBarController.selectedViewController;
        UINavigationController *tabNavController = (UINavigationController *) tabBarController.selectedViewController;
        
        DDLogDebug(@"tabNavController = %@", tabNavController);
        [tabNavController pushViewController:viewController animated:YES];
    }
    else {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (BOOL)isVisibleViewController:(UIViewController *)viewController {
    return [self.navigationController visibleViewController] == viewController;
}

@end
