#import "RTLoginAssembly.h"
#import "RTStoryboardViewControllerFactory.h"

@implementation RTLoginAssembly

- (RTLoginWireframe *)wireframe {
    return [TyphoonDefinition withClass:[RTLoginWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithPresenter:viewController:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self presenter]];
                          [initializer injectParameterWith:[self viewController]];
        }];
    }];
}

- (RTLoginViewController *)viewController {
    return [TyphoonDefinition withClass:[RTStoryboardViewControllerFactory class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(loginViewController)];
        [definition injectProperty:@selector(presenter) with:[self presenter]];
    }];
}

- (RTLoginPresenter *)presenter {
    return [TyphoonDefinition withClass:[RTLoginPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self viewController]];
                          [initializer injectParameterWith:[self interactor]];
                          [initializer injectParameterWith:[self wireframe]];
        }];
    }];
}

- (RTLoginInteractor *)interactor {
    return [TyphoonDefinition withClass:[RTLoginInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithPresenter:dataManager:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self presenter]];
                          [initializer injectParameterWith:[self dataManager]];
        }];
    }];
}

- (RTLoginDataManager *)dataManager {
    return [TyphoonDefinition withClass:[RTLoginDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithInteractor:client:clientCredentialsStore:tokenStore:currentUserStore:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self interactor]];
                          [initializer injectParameterWith:[self.clientAssembly reelTimeClient]];
                          [initializer injectParameterWith:[self.secureStoreAssembly clientCredentialsStore]];
                          [initializer injectParameterWith:[self.secureStoreAssembly tokenStore]];
                          [initializer injectParameterWith:[self.secureStoreAssembly currentUserStore]];
        }];
    }];
}


@end
