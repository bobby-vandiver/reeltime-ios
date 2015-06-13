#import "RTChangePasswordAssembly.h"

#import "RTClientAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTChangePasswordWireframe.h"
#import "RTChangePasswordViewController.h"
#import "RTChangePasswordPresenter.h"
#import "RTChangePasswordInteractor.h"
#import "RTChangePasswordDataManager.h"

@implementation RTChangePasswordAssembly

- (RTChangePasswordWireframe *)changePasswordWireframe {
    return [TyphoonDefinition withClass:[RTChangePasswordWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:applicationWireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self changePasswordViewController]];
            [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTChangePasswordViewController *)changePasswordViewController {
    return [TyphoonDefinition withClass:[RTChangePasswordViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithPresenter:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self changePasswordPresenter]];
        }];
    }];
}

- (RTChangePasswordPresenter *)changePasswordPresenter {
    return [TyphoonDefinition withClass:[RTChangePasswordPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self changePasswordViewController]];
            [method injectParameterWith:[self changePasswordInteractor]];
        }];
    }];
}

- (RTChangePasswordInteractor *)changePasswordInteractor {
    return [TyphoonDefinition withClass:[RTChangePasswordInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self changePasswordPresenter]];
            [method injectParameterWith:[self changePasswordDataManager]];
        }];
    }];
}

- (RTChangePasswordDataManager *)changePasswordDataManager {
    return [TyphoonDefinition withClass:[RTChangePasswordDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

@end
