#import "RTApplicationAssembly.h"
#import "RTApplicationWireframe.h"

#import "RTApplicationTabBarController.h"

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
        [definition injectMethod:@selector(initWithWindow:tabBarController:loginWireframe:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self mainWindow]];
                          [initializer injectParameterWith:[self applicationTabBarController]];
                          [initializer injectParameterWith:[self.loginAssembly loginWireframe]];
        }];
        
        // TODO: Only for testing purposes -- should be removed!
        [definition injectProperty:@selector(browseViewController) with:[self.browseAssembly browseAllViewController]];
    }];
}

- (RTApplicationTabBarController *)applicationTabBarController {
    return [TyphoonDefinition withClass:[RTApplicationTabBarController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(viewControllers) with:[self applicationTabBarViewControllers]];
    }];
}

- (NSArray *)applicationTabBarViewControllers {
    NSArray *controllers = @[[self.newsfeedAssembly newsfeedViewController], [self sampleController]];
    
    return [TyphoonDefinition withClass:[NSMutableArray class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithArray:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:controllers];
        }];
    }];
}

- (UIViewController *)sampleController {
    return [TyphoonDefinition withClass:[UIViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"sample"];
    }];
}

@end
