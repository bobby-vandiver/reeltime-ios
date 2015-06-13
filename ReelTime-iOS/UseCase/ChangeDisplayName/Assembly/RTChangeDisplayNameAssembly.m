#import "RTChangeDisplayNameAssembly.h"

#import "RTClientAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTChangeDisplayNameWireframe.h"
#import "RTChangeDisplayNameViewController.h"
#import "RTChangeDisplayNamePresenter.h"
#import "RTChangeDisplayNameInteractor.h"
#import "RTChangeDisplayNameDataManager.h"

@implementation RTChangeDisplayNameAssembly

- (RTChangeDisplayNameWireframe *)changeDisplayNameWireframe {
    return [TyphoonDefinition withClass:[RTChangeDisplayNameWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:applicationWireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self changeDisplayNameViewController]];
            [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTChangeDisplayNameViewController *)changeDisplayNameViewController {
    return [TyphoonDefinition withClass:[RTChangeDisplayNameViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithPresenter:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self changeDisplayNamePresenter]];
        }];
    }];
}

- (RTChangeDisplayNamePresenter *)changeDisplayNamePresenter {
    return [TyphoonDefinition withClass:[RTChangeDisplayNamePresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self changeDisplayNameViewController]];
            [method injectParameterWith:[self changeDisplayNameInteractor]];
        }];
    }];
}

- (RTChangeDisplayNameInteractor *)changeDisplayNameInteractor {
    return [TyphoonDefinition withClass:[RTChangeDisplayNameInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self changeDisplayNamePresenter]];
            [method injectParameterWith:[self changeDisplayNameDataManager]];
        }];
    }];
}

- (RTChangeDisplayNameDataManager *)changeDisplayNameDataManager {
    return [TyphoonDefinition withClass:[RTChangeDisplayNameDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

@end
