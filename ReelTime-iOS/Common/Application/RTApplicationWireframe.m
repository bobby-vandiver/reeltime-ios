#import "RTApplicationWireframe.h"

#import "RTApplicationTabBarController.h"
#import "RTLoginWireframe.h"

#import "RTBrowseViewController.h"

@interface RTApplicationWireframe ()

@property (nonatomic) UIWindow *window;
@property RTApplicationTabBarController *tabBarController;
@property RTLoginWireframe *loginWirefame;

@end

@implementation RTApplicationWireframe

- (instancetype)initWithWindow:(UIWindow *)window
              tabBarController:(RTApplicationTabBarController *)tabBarController
                loginWireframe:(RTLoginWireframe *)loginWireframe {
    self = [super init];
    if (self) {
        self.window = window;
        self.tabBarController = tabBarController;
        self.loginWirefame = loginWireframe;
    }
    return self;
}

- (void)presentInitialScreen {
//    [self.loginWirefame presentLoginInterfaceFromWindow:self.window];
    
    // TODO: Remove this and re-enable associated test in RTApplicationWireframeSpec
    self.window.rootViewController = self.browseViewController;
}

- (void)presentTabBarManagedScreen {
    self.window.rootViewController = self.tabBarController;
}

@end
