#import "RTAccountRegistrationAutoLoginAssembly.h"

#import "RTClientAssembly.h"
#import "RTSecureStoreAssembly.h"
#import "RTCommonComponentsAssembly.h"
#import "RTAccountRegistrationAssembly.h"

#import "RTLoginPresenter.h"
#import "RTLoginInteractor.h"
#import "RTLoginDataManager.h"

@implementation RTAccountRegistrationAutoLoginAssembly

- (RTLoginInteractor *)accountRegistrationAutoLoginInteractor {
    return [TyphoonDefinition withClass:[RTLoginInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:notificationCenter:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self.accountRegistrationAssembly accountRegistrationPresenter]];
                          [initializer injectParameterWith:[self accountRegistrationAutoLoginDataManager]];
                          [initializer injectParameterWith:[self.commonComponentsAssembly notificationCenter]];
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
