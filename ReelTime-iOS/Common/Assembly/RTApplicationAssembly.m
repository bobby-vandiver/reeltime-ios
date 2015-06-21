#import "RTApplicationAssembly.h"
#import "RTApplicationWireframe.h"

#import "RTApplicationNavigationController.h"
#import "RTApplicationTabBarController.h"

#import "RTApplicationWireframeContainer.h"

#import "RTNewsfeedViewController.h"
#import "RTBrowseAllViewController.h"

@implementation RTApplicationAssembly

- (RTAppDelegate *)appDelegate {
    return [TyphoonDefinition withClass:[RTAppDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(window) with:[self mainWindow]];
        [definition injectProperty:@selector(applicationWireframe) with:[self applicationWireframe]];
    }];
}

- (UIWindow *)mainWindow {
    return [TyphoonDefinition withClass:[UIWindow class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
        
        [definition useInitializer:@selector(initWithFrame:)
                        parameters:^(TyphoonMethod *initializer) {
                            CGRect bounds = [[UIScreen mainScreen] bounds];
                            [initializer injectParameterWith:[NSValue valueWithCGRect:bounds]];
        }];
    }];
}

- (RTApplicationWireframe *)applicationWireframe {
    return [TyphoonDefinition withClass:[RTApplicationWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithWindow:navigationController:tabBarController:wireframeContainer:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self mainWindow]];
                          [initializer injectParameterWith:[self applicationNavigationController]];
                          [initializer injectParameterWith:[self applicationTabBarController]];
                          [initializer injectParameterWith:[self applicationWireframeContainer]];
        }];
    }];
}

- (RTApplicationWireframeContainer *)applicationWireframeContainer {
    return [TyphoonDefinition withClass:[RTApplicationWireframeContainer class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(loginWireframe) with:[self.loginAssembly loginWireframe]];
    }];
}

- (RTApplicationNavigationController *)applicationNavigationController {
    return [TyphoonDefinition withClass:[RTApplicationNavigationController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithoutRootViewController)];
    }];    
}

- (RTApplicationTabBarController *)applicationTabBarController {
    return [TyphoonDefinition withClass:[RTApplicationTabBarController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(viewControllers) with:[self applicationTabBarViewControllers]];
    }];
}

- (NSArray *)applicationTabBarViewControllers {
    return [TyphoonDefinition withClass:[NSMutableArray class] configuration:^(TyphoonDefinition *definition) {

        RTNewsfeedViewController *newsfeedViewController = [self.newsfeedAssembly newsfeedViewController];
        RTBrowseAllViewController *browseAllViewController = [self.browseAllAssembly browseAllViewController];
        
        [definition useInitializer:@selector(array)];

        [definition injectMethod:@selector(insertObject:atIndex:) parameters:^(TyphoonMethod *method) {
            UIViewController *vc = [self navigationControllerWithRootViewController:newsfeedViewController];
            [method injectParameterWith:vc];
            [method injectParameterWith:@(0)];
        }];
        
        [definition injectMethod:@selector(insertObject:atIndex:) parameters:^(TyphoonMethod *method) {
            UIViewController *vc = [self navigationControllerWithRootViewController:browseAllViewController];
            [method injectParameterWith:vc];
            [method injectParameterWith:@(1)];
        }];
    }];
}

- (UIViewController *)navigationControllerWithRootViewController:(UIViewController *)viewController {
    return [TyphoonDefinition withClass:[UINavigationController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithRootViewController:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:viewController];
        }];
    }];
}

@end
