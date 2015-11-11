#import "RTRecordVideoAssembly.h"
#import "RTCaptureThumbnailAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTRecordVideoViewController.h"
#import "RTRecordVideoWireframe.h"
#import "RTRecordVideoPresenter.h"

@implementation RTRecordVideoAssembly

- (RTRecordVideoViewController *)recordVideoViewController {
    return [TyphoonDefinition withClass:[RTRecordVideoViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithPresenter:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self recordVideoPresenter]];
        }];
    }];
}

- (RTRecordVideoWireframe *)recordVideoWireframe {
    return [TyphoonDefinition withClass:[RTRecordVideoWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:captureThumbnailWireframe:applicationWireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self recordVideoViewController]];
                          [method injectParameterWith:[self.captureThumbnailAssembly captureThumbnailWireframe]];
                          [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTRecordVideoPresenter *)recordVideoPresenter {
    return [TyphoonDefinition withClass:[RTRecordVideoPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithWireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self recordVideoWireframe]];
        }];
    }];
}

@end
