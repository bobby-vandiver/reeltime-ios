#import "RTAccountRegistrationAssembly.h"

#import "RTClientAssembly.h"
#import "RTSecureStoreAssembly.h"

#import "RTLoginAssembly.h"
#import "RTAccountRegistrationAutoLoginAssembly.h"

#import "RTAccountRegistrationWireframe.h"
#import "RTAccountRegistrationViewController.h"
#import "RTAccountRegistrationPresenter.h"
#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationDataManager.h"

#import "RTAccountRegistrationValidator.h"

@implementation RTAccountRegistrationAssembly

- (RTAccountRegistrationWireframe *)accountRegistrationWireframe {
    return [TyphoonDefinition withClass:[RTAccountRegistrationWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithViewController:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self accountRegistrationViewController]];
        }];
    }];
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
                          [initializer injectParameterWith:[self.accountRegistrationAutoLoginAssembly accountRegistrationAutoLoginInteractor]];
        }];
    }];
}

- (RTAccountRegistrationValidator *)accountRegistrationValidator {
    return [TyphoonDefinition withClass:[RTAccountRegistrationValidator class]];
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
