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

@property (readonly) RTApplicationNavigationController *rootNavigationController;
@property (readonly) RTApplicationTabBarController *rootTabBarController;

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

- (RTApplicationNavigationController *)rootNavigationController {
    return [self rootViewControllerIfKindOfClass:[RTApplicationNavigationController class]];
}

- (RTApplicationTabBarController *)rootTabBarController {
    return [self rootViewControllerIfKindOfClass:[RTApplicationTabBarController class]];
}

- (id)rootViewControllerIfKindOfClass:(Class)clazz {
    UIViewController *rootViewController = self.window.rootViewController;
    return [rootViewController isKindOfClass:clazz] ? rootViewController : nil;
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

- (void)navigateToViewController:(UIViewController *)viewController {
    BOOL onTabBarManagedScreen = [self.window.rootViewController isKindOfClass:[UITabBarController class]];

    if (onTabBarManagedScreen) {
        UINavigationController *tabNavController = (UINavigationController *) self.rootTabBarController.selectedViewController;
        [tabNavController pushViewController:viewController animated:YES];
    }
    else {
        [self.rootNavigationController pushViewController:viewController animated:YES];
    }
}

- (void)resetNavigationToViewController:(UIViewController *)viewController {
    BOOL onTabBarManagedScreen = [self.window.rootViewController isKindOfClass:[UITabBarController class]];
    
    if (onTabBarManagedScreen) {
        UINavigationController *tabNavController = (UINavigationController *) self.rootTabBarController.selectedViewController;
        [tabNavController setViewControllers:@[viewController] animated:NO];
    }
    else {
        [self.rootNavigationController setViewControllers:@[viewController] animated:NO];
    }
}

- (BOOL)isVisibleViewController:(UIViewController *)viewController {
    return [self.rootNavigationController visibleViewController] == viewController;
}

@end
