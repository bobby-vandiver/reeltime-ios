#import "RTApplicationWireframe.h"

#import "RTApplicationNavigationController.h"
#import "RTApplicationTabBarController.h"
#import "RTApplicationWireframeContainer.h"

#import "RTLoginWireframe.h"

#import "RTBrowseAllViewController.h"

@interface RTApplicationWireframe ()

@property (nonatomic) UIWindow *window;

@property RTApplicationNavigationController *navigationController;
@property RTApplicationTabBarController *tabBarController;

@property RTApplicationWireframeContainer *wireframeContainer;

@end

@implementation RTApplicationWireframe

- (instancetype)initWithWindow:(UIWindow *)window
          navigationController:(RTApplicationNavigationController *)navigationController
              tabBarController:(RTApplicationTabBarController *)tabBarController
            wireframeContainer:(RTApplicationWireframeContainer *)wireframeContainer {
    self = [super init];
    if (self) {
        self.window = window;
        self.navigationController = navigationController;
        self.tabBarController = tabBarController;
        self.wireframeContainer = wireframeContainer;
    }
    return self;
}

- (void)presentInitialScreen {
    [self.wireframeContainer.loginWireframe presentLoginInterface];
}

- (void)presentTabBarManagedScreen {
    self.window.rootViewController = self.tabBarController;
}

- (void)presentNavigationRootViewController:(UIViewController *)viewController {
    self.window.rootViewController = self.navigationController;
    [self.navigationController setRootViewController:viewController];
}

@end
