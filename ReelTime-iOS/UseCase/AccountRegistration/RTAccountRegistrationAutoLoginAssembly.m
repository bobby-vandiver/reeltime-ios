#import "RTAccountRegistrationAutoLoginAssembly.h"

#import "RTClientAssembly.h"
#import "RTSecureStoreAssembly.h"
#import "RTAccountRegistrationAssembly.h"

#import "RTAccountRegistrationAutoLoginPresenter.h"

#import "RTLoginPresenter.h"
#import "RTLoginInteractor.h"
#import "RTLoginDataManager.h"

@implementation RTAccountRegistrationAutoLoginAssembly

- (RTAccountRegistrationAutoLoginPresenter *)accountRegistrationAutoLoginPresenter {
    return [TyphoonDefinition withClass:[RTAccountRegistrationAutoLoginPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithAccountRegistrationPresenter:loginInteractor:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self.accountRegistrationAssembly accountRegistrationPresenter]];
                          [initializer injectParameterWith:[self accountRegistrationAutoLoginInteractor]];
        }];
    }];
}

- (RTLoginInteractor *)accountRegistrationAutoLoginInteractor {
    return [TyphoonDefinition withClass:[RTLoginInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self accountRegistrationAutoLoginPresenter]];
                          [initializer injectParameterWith:[self accountRegistrationAutoLoginDataManager]];
        }];
    }];
}

- (RTLoginDataManager *)accountRegistrationAutoLoginDataManager {
    return [TyphoonDefinition withClass:[RTLoginDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:client:clientCredentialsStore:tokenStore:currentUserStore:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self accountRegistrationAutoLoginInteractor]];
                          [initializer injectParameterWith:[self.clientAssembly reelTimeClient]];
                          [initializer injectParameterWith:[self.secureStoreAssembly clientCredentialsStore]];
                          [initializer injectParameterWith:[self.secureStoreAssembly tokenStore]];
                          [initializer injectParameterWith:[self.secureStoreAssembly currentUserStore]];
        }];
    }];
}

@end
