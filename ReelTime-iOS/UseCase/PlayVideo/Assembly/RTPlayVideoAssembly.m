#import "RTPlayVideoAssembly.h"

#import "RTClientAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTCommonComponentsAssembly.h"

#import "RTPlayVideoWireframe.h"
#import "RTPlayVideoViewController.h"

#import "RTPlayerFactory.h"

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
        [definition useInitializer:@selector(viewControllerForVideoId:withPlayerFactory:notificationCenter:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:videoId];
            [initializer injectParameterWith:[self playerFactory]];
            [initializer injectParameterWith:[self.commonComponentsAssembly notificationCenter]];
        }];
    }];
}

- (RTPlayerFactory *)playerFactory {
    return [TyphoonDefinition withClass:[RTPlayerFactory class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithServerUrl:pathFormatter:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.clientAssembly baseUrl]];
            [method injectParameterWith:[self.clientAssembly endpointPathFormatter]];
        }];
    }];
}

@end
