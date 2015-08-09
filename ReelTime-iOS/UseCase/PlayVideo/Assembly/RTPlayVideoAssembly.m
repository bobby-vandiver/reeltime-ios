#import "RTPlayVideoAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTPlayVideoWireframe.h"
#import "RTPlayVideoViewController.h"

@implementation RTPlayVideoAssembly

- (RTPlayVideoWireframe *)playVideoWireframe {
    return [TyphoonDefinition withClass:[RTPlayVideoWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewControllerFactory:applicationWireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:self];
            [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTPlayVideoViewController *)playVideoViewControllerForVideoId:(NSNumber *)videoId {
    return [TyphoonDefinition withClass:[RTPlayVideoViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerForVideoId:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:videoId];
        }];
    }];
}

@end
