#import "RTConfirmAccountAssembly.h"

#import "RTClientAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTConfirmAccountWireframe.h"
#import "RTConfirmAccountViewController.h"
#import "RTConfirmAccountPresenter.h"
#import "RTConfirmAccountInteractor.h"
#import "RTConfirmAccountDataManager.h"

@implementation RTConfirmAccountAssembly

- (RTConfirmAccountWireframe *)confirmAccountWireframe {
    return [TyphoonDefinition withClass:[RTConfirmAccountWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:applicationWireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self confirmAccountViewController]];
            [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTConfirmAccountViewController *)confirmAccountViewController {
    return [TyphoonDefinition withClass:[RTConfirmAccountViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithPresenter:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self confirmAccountPresenter]];
        }];
    }];
}

- (RTConfirmAccountPresenter *)confirmAccountPresenter {
    return [TyphoonDefinition withClass:[RTConfirmAccountPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self confirmAccountViewController]];
            [method injectParameterWith:[self confirmAccountInteractor]];
        }];
    }];
}

- (RTConfirmAccountInteractor *)confirmAccountInteractor {
    return [TyphoonDefinition withClass:[RTConfirmAccountInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self confirmAccountPresenter]];
            [method injectParameterWith:[self confirmAccountDataManager]];
        }];
    }];
}

- (RTConfirmAccountDataManager *)confirmAccountDataManager {
    return [TyphoonDefinition withClass:[RTConfirmAccountDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

@end
