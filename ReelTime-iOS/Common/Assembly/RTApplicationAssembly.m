#import "RTApplicationAssembly.h"
#import "RTApplicationWireframe.h"

#import "RTApplicationWindowHandle.h"

#import "RTApplicationNavigationController.h"
#import "RTApplicationTabBarController.h"

#import "RTApplicationWireframeContainer.h"

#import "RTRecordVideoViewController.h"
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
        [definition useInitializer:@selector(initWithFrame:)
                        parameters:^(TyphoonMethod *initializer) {
                            CGRect bounds = [[UIScreen mainScreen] bounds];
                            [initializer injectParameterWith:[NSValue valueWithCGRect:bounds]];
        }];
    }];
}

- (RTApplicationWindowHandle *)applicationWindowHandle {
    return [TyphoonDefinition withClass:[RTApplicationWindowHandle class]];
}

- (RTApplicationWireframe *)applicationWireframe {
    return [TyphoonDefinition withClass:[RTApplicationWireframe class] configuration:^(TyphoonDefinition *definition) {        
        [definition injectMethod:@selector(initWithWindowHandle:tabBarController:wireframeContainer:navigationControllerFactory:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self applicationWindowHandle]];
                          [initializer injectParameterWith:[self applicationTabBarController]];
                          [initializer injectParameterWith:[self applicationWireframeContainer]];
                          [initializer injectParameterWith:self];
        }];
    }];
}

- (RTApplicationWireframeContainer *)applicationWireframeContainer {
    return [TyphoonDefinition withClass:[RTApplicationWireframeContainer class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(loginWireframe) with:[self.loginAssembly loginWireframe]];
    }];
}

- (RTApplicationNavigationController *)applicationNavigationControllerWithRootViewController:(UIViewController *)rootViewController {
    return [TyphoonDefinition withClass:[RTApplicationNavigationController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithRootViewController:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:rootViewController];
        }];
    }];
}

- (RTApplicationTabBarController *)applicationTabBarController {
    return [TyphoonDefinition withClass:[RTApplicationTabBarController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(viewControllers) with:[self applicationTabBarViewControllers]];
    }];
}

- (NSArray *)applicationTabBarViewControllers {
    return [TyphoonDefinition withClass:[NSMutableArray class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(array)];

        RTRecordVideoViewController *recordVideoViewController = [self.recordVideoAssembly recordVideoViewController];

        [definition injectMethod:@selector(addObject:) parameters:^(TyphoonMethod *method) {
            UIViewController *vc = [self navigationControllerWithRootViewController:recordVideoViewController];
            [method injectParameterWith:vc];
        }];
        
        RTNewsfeedViewController *newsfeedViewController = [self.newsfeedAssembly newsfeedViewController];

        [definition injectMethod:@selector(addObject:) parameters:^(TyphoonMethod *method) {
            UIViewController *vc = [self navigationControllerWithRootViewController:newsfeedViewController];
            [method injectParameterWith:vc];
        }];
        
        RTBrowseAllViewController *browseAllViewController = [self.browseAllAssembly browseAllViewController];

        [definition injectMethod:@selector(addObject:) parameters:^(TyphoonMethod *method) {
            UIViewController *vc = [self navigationControllerWithRootViewController:browseAllViewController];
            [method injectParameterWith:vc];
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
