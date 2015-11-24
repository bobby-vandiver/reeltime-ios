#import "RTRemoveAccountAssembly.h"

#import "RTClientAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTRemoveAccountWireframe.h"
#import "RTRemoveAccountViewController.h"
#import "RTRemoveAccountPresenter.h"
#import "RTRemoveAccountInteractor.h"
#import "RTRemoveAccountDataManager.h"

@implementation RTRemoveAccountAssembly

- (RTRemoveAccountWireframe *)removeAccountWireframe {
    return [TyphoonDefinition withClass:[RTRemoveAccountWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:applicationWireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self removeAccountViewController]];
                          [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTRemoveAccountViewController *)removeAccountViewController {
    return [TyphoonDefinition withClass:[RTRemoveAccountViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithPresenter:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self removeAccountPresenter]];
        }];
    }];
}

- (RTRemoveAccountPresenter *)removeAccountPresenter {
    return [TyphoonDefinition withClass:[RTRemoveAccountPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self removeAccountViewController]];
            [method injectParameterWith:[self removeAccountInteractor]];
            [method injectParameterWith:[self removeAccountWireframe]];
        }];
    }];
}

- (RTRemoveAccountInteractor *)removeAccountInteractor {
    return [TyphoonDefinition withClass:[RTRemoveAccountInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self removeAccountPresenter]];
            [method injectParameterWith:[self removeAccountDataManager]];
        }];
    }];
}

- (RTRemoveAccountDataManager *)removeAccountDataManager {
    return [TyphoonDefinition withClass:[RTRemoveAccountDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

@end
