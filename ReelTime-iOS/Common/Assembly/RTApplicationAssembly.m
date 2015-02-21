#import "RTApplicationAssembly.h"
#import "RTApplicationWireframe.h"

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

- (RTApplicationWireframe *)applicationWireframe {
    return [TyphoonDefinition withClass:[RTApplicationWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithLoginWireframe:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self.loginAssembly loginWireframe]];
        }];
    }];
}

@end
