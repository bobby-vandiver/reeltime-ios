#import "RTCaptureThumbnailAssembly.h"

#import "RTUploadVideoAssembly.h"
#import "RTPlayVideoAssembly.h"

#import "RTCommonComponentsAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTCaptureThumbnailWireframe.h"
#import "RTCaptureThumbnailViewController.h"
#import "RTCaptureThumbnailPresenter.h"

@implementation RTCaptureThumbnailAssembly

- (RTCaptureThumbnailWireframe *)captureThumbnailWireframe {
    return [TyphoonDefinition withClass:[RTCaptureThumbnailWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewControllerFactory:uploadVideoWireframe:applicationWireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:self];
                          [method injectParameterWith:[self.uploadVideoAssembly uploadVideoWireframe]];
                          [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTCaptureThumbnailViewController *)captureThumbnailViewControllerForVideo:(NSURL *)videoURL {
    return [TyphoonDefinition withClass:[RTCaptureThumbnailViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerForVideo:withPresenter:playerFactory:notificationCenter:filePathGenerator:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:videoURL];
                            [initializer injectParameterWith:[self captureThumbnailPresenterForVideo:videoURL]];
                            [initializer injectParameterWith:[self.playVideoAssembly playerFactory]];
                            [initializer injectParameterWith:[self.commonComponentsAssembly notificationCenter]];
                            [initializer injectParameterWith:[self.commonComponentsAssembly filePathGenerator]];
        }];
    }];
}

- (RTCaptureThumbnailPresenter *)captureThumbnailPresenterForVideo:(NSURL *)videoURL {
    return [TyphoonDefinition withClass:[RTCaptureThumbnailPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithWireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self captureThumbnailWireframe]];
        }];
    }];
}

@end
