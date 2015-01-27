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

#import "RTStoryboardViewControllerFactory.h"

@implementation RTAccountRegistrationAssembly

- (RTAccountRegistrationWireframe *)wireframe {
    return [TyphoonDefinition withClass:[RTAccountRegistrationWireframe class]];
}

- (RTAccountRegistrationViewController *)viewController {
    return [TyphoonDefinition withClass:[RTStoryboardViewControllerFactory class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(accountRegistrationViewController)];
        [definition injectProperty:@selector(presenter) with:[self presenter]];
    }];
}

- (RTAccountRegistrationPresenter *)presenter {
    return [TyphoonDefinition withClass:[RTAccountRegistrationPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self viewController]];
                          [initializer injectParameterWith:[self interactor]];
                          [initializer injectParameterWith:[self wireframe]];
        }];
    }];
}

- (RTAccountRegistrationInteractor *)interactor {
    return [TyphoonDefinition withClass:[RTAccountRegistrationInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:validator:loginInteractor:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self presenter]];
                          [initializer injectParameterWith:[self dataManager]];
                          [initializer injectParameterWith:[self validator]];
                          [initializer injectParameterWith:[self autoLoginInteractor]];
        }];
    }];
}

- (RTAccountRegistrationValidator *)validator {
    return [TyphoonDefinition withClass:[RTAccountRegistrationValidator class]];
}

- (RTLoginInteractor *)autoLoginInteractor {
    return [TyphoonDefinition withClass:[RTLoginInteractor class] configuration:^(TyphoonDefinition *definition) {
        
    }];
}

- (RTAccountRegistrationAutoLoginPresenter *)autoLoginPresenter {
    return [TyphoonDefinition withClass:[RTAccountRegistrationAutoLoginPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithAccountRegistrationPresenter:loginInteractor:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self presenter]];
                          [initializer injectParameterWith:[self.loginAssembly interactor]];
        }];
    }];
}

- (RTAccountRegistrationDataManager *)dataManager {
    return [TyphoonDefinition withClass:[RTAccountRegistrationDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:client:serverErrorsConverter:clientCredentialsStore:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self interactor]];
                          [initializer injectParameterWith:[self.clientAssembly reelTimeClient]];
                          [initializer injectParameterWith:[self.clientAssembly serverErrorsConverter]];
                          [initializer injectParameterWith:[self.secureStoreAssembly clientCredentialsStore]];
        }];
    }];
}

@end
