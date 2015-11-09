#import "RTUploadVideoAssembly.h"

#import "RTClientAssembly.h"
#import "RTRecordVideoAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTUploadVideoWireframe.h"
#import "RTUploadVideoViewController.h"
#import "RTUploadVideoPresenter.h"
#import "RTUploadVideoInteractor.h"
#import "RTUploadVideoValidator.h"
#import "RTUploadVideoDataManager.h"

@implementation RTUploadVideoAssembly

- (RTUploadVideoWireframe *)uploadVideoWireframe {
    return [TyphoonDefinition withClass:[RTUploadVideoWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewControllerFactory:recordVideoWireframe:applicationWireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:self];
                          [method injectParameterWith:[self.recordVideoAssembly recordVideoWireframe]];
                          [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTUploadVideoViewController *)uploadVideoViewControllerForVideo:(NSURL *)videoUrl thumbnail:(NSURL *)thumbnailUrl {
    return [TyphoonDefinition withClass:[RTUploadVideoViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithPresenter:forVideo:thumbnail:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self uploadVideoPresenterForVideo:videoUrl thumbnail:thumbnailUrl]];
                            [initializer injectParameterWith:videoUrl];
                            [initializer injectParameterWith:thumbnailUrl];
        }];
    }];
}

- (RTUploadVideoPresenter *)uploadVideoPresenterForVideo:(NSURL *)videoUrl thumbnail:(NSURL *)thumbnailUrl {
    return [TyphoonDefinition withClass:[RTUploadVideoPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self uploadVideoViewControllerForVideo:videoUrl thumbnail:thumbnailUrl]];
            [method injectParameterWith:[self uploadVideoInteractorForVideo:(NSURL *)videoUrl thumbnail:(NSURL *)thumbnailUrl]];
            [method injectParameterWith:[self uploadVideoWireframe]];
        }];
    }];
}

- (RTUploadVideoInteractor *)uploadVideoInteractorForVideo:(NSURL *)videoUrl thumbnail:(NSURL *)thumbnailUrl {
    return [TyphoonDefinition withClass:[RTUploadVideoInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:validator:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self uploadVideoPresenterForVideo:videoUrl thumbnail:thumbnailUrl]];
            [method injectParameterWith:[self uploadVideoDataManager]];
            [method injectParameterWith:[self uploadVideoValidator]];
        }];
    }];
}

- (RTUploadVideoValidator *)uploadVideoValidator {
    return [TyphoonDefinition withClass:[RTUploadVideoValidator class]];
}

- (RTUploadVideoDataManager *)uploadVideoDataManager {
    return [TyphoonDefinition withClass:[RTUploadVideoDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

@end
