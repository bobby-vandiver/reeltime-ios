#import "RTApplicationWireframe.h"

#import "RTApplicationNavigationController.h"
#import "RTApplicationTabBarController.h"
#import "RTApplicationWireframeContainer.h"
#import "RTApplicationNavigationControllerFactory.h"

#import "RTLoginWireframe.h"
#import "RTBrowseAllViewController.h"

@interface RTApplicationWireframe ()

@property (nonatomic) UIWindow *window;

@property RTApplicationNavigationController *navigationController;
@property RTApplicationTabBarController *tabBarController;

@property RTApplicationWireframeContainer *wireframeContainer;
@property id<RTApplicationNavigationControllerFactory> navigationControllerFactory;

@property UIViewController *previousRootViewController;

@end

@implementation RTApplicationWireframe

- (instancetype)initWithWindow:(UIWindow *)window
              tabBarController:(RTApplicationTabBarController *)tabBarController
            wireframeContainer:(RTApplicationWireframeContainer *)wireframeContainer
   navigationControllerFactory:(id<RTApplicationNavigationControllerFactory>)navigationControllerFactory {
    self = [super init];
    if (self) {
        self.window = window;
        self.tabBarController = tabBarController;
        self.wireframeContainer = wireframeContainer;
        self.navigationControllerFactory = navigationControllerFactory;
    }
    return self;
}

- (void)presentInitialScreen {
    [self.wireframeContainer.loginWireframe presentLoginInterface];
}

- (void)presentPreviousScreen {
    if (self.previousRootViewController) {
        self.window.rootViewController = self.previousRootViewController;
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
    BOOL onTabBarManagedScreen = (self.window.rootViewController == self.tabBarController);
    
    if (onTabBarManagedScreen) {
        UINavigationController *tabNavController = (UINavigationController *) self.tabBarController.selectedViewController;
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
