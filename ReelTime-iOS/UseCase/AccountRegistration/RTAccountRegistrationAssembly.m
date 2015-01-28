#import "RTAccountRegistrationAssembly.h"

#import "RTClientAssembly.h"
#import "RTSecureStoreAssembly.h"

#import "RTLoginAssembly.h"
#import "RTLoginInteractor.h"

#import "RTAccountRegistrationWireframe.h"
#import "RTAccountRegistrationViewController.h"
#import "RTAccountRegistrationPresenter.h"
#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationDataManager.h"

#import "RTAccountRegistrationValidator.h"
#import "RTAccountRegistrationAutoLoginPresenter.h"

@implementation RTAccountRegistrationAssembly

- (RTAccountRegistrationWireframe *)accountRegistrationWireframe {
    return [TyphoonDefinition withClass:[RTAccountRegistrationWireframe class]];
}

- (RTAccountRegistrationViewController *)accountRegistrationViewController {
    return [TyphoonDefinition withClass:[RTAccountRegistrationViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithPresenter:)
                        parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self accountRegistrationPresenter]];
        }];
    }];
}

- (RTAccountRegistrationPresenter *)accountRegistrationPresenter {
    return [TyphoonDefinition withClass:[RTAccountRegistrationPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self accountRegistrationViewController]];
                          [initializer injectParameterWith:[self accountRegistrationInteractor]];
                          [initializer injectParameterWith:[self accountRegistrationWireframe]];
        }];
    }];
}

- (RTAccountRegistrationInteractor *)accountRegistrationInteractor {
    return [TyphoonDefinition withClass:[RTAccountRegistrationInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:validator:loginInteractor:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self accountRegistrationPresenter]];
                          [initializer injectParameterWith:[self accountRegistrationDataManager]];
                          [initializer injectParameterWith:[self accountRegistrationValidator]];
                          [initializer injectParameterWith:[self accountRegistrationAutoLoginInteractor]];
        }];
    }];
}

- (RTAccountRegistrationValidator *)accountRegistrationValidator {
    return [TyphoonDefinition withClass:[RTAccountRegistrationValidator class]];
}

- (RTLoginInteractor *)accountRegistrationAutoLoginInteractor {
    return [TyphoonDefinition withClass:[RTLoginInteractor class] configuration:^(TyphoonDefinition *definition) {
        
    }];
}

- (RTAccountRegistrationAutoLoginPresenter *)accountRegistrationAutoLoginPresenter {
    return [TyphoonDefinition withClass:[RTAccountRegistrationAutoLoginPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithAccountRegistrationPresenter:loginInteractor:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self accountRegistrationPresenter]];
                          [initializer injectParameterWith:[self.loginAssembly loginInteractor]];
        }];
    }];
}

- (RTAccountRegistrationDataManager *)accountRegistrationDataManager {
    return [TyphoonDefinition withClass:[RTAccountRegistrationDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:client:serverErrorsConverter:clientCredentialsStore:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self accountRegistrationInteractor]];
                          [initializer injectParameterWith:[self.clientAssembly reelTimeClient]];
                          [initializer injectParameterWith:[self.clientAssembly serverErrorsConverter]];
                          [initializer injectParameterWith:[self.secureStoreAssembly clientCredentialsStore]];
        }];
    }];
}

@end
