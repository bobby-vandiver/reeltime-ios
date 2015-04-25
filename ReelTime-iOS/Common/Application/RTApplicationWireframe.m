#import "RTApplicationWireframe.h"

#import "RTApplicationTabBarController.h"
#import "RTApplicationWireframeContainer.h"

#import "RTLoginWireframe.h"

#import "RTBrowseAllViewController.h"

@interface RTApplicationWireframe ()

@property (nonatomic) UIWindow *window;

@property RTApplicationTabBarController *tabBarController;
@property RTApplicationWireframeContainer *wireframeContainer;

@end

@implementation RTApplicationWireframe

- (instancetype)initWithWindow:(UIWindow *)window
              tabBarController:(RTApplicationTabBarController *)tabBarController
            wireframeContainer:(RTApplicationWireframeContainer *)wireframeContainer {
    self = [super init];
    if (self) {
        self.window = window;
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

@end
