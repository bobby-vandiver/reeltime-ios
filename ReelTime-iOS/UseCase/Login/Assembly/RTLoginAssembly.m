#import "RTLoginAssembly.h"

#import "RTClientAssembly.h"
#import "RTSecureStoreAssembly.h"

#import "RTCommonComponentsAssembly.h"

#import "RTAccountRegistrationAssembly.h"
#import "RTDeviceRegistrationAssembly.h"

#import "RTResetPasswordAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTLoginWireframe.h"
#import "RTLoginViewController.h"
#import "RTLoginPresenter.h"
#import "RTLoginInteractor.h"
#import "RTLoginDataManager.h"

@implementation RTLoginAssembly

- (RTLoginWireframe *)loginWireframe {
    return [TyphoonDefinition withClass:[RTLoginWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:accountRegistrationWireframe:deviceRegistrationWireframe:resetPasswordWireframe:applicationWireframe:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self loginViewController]];
                          [initializer injectParameterWith:[self.accountRegistrationAssembly accountRegistrationWireframe]];
                          [initializer injectParameterWith:[self.deviceRegistrationAssembly deviceRegistrationWireframe]];
                          [initializer injectParameterWith:[self.resetPasswordAssembly resetPasswordWireframe]];
                          [initializer injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTLoginViewController *)loginViewController {
    return [TyphoonDefinition withClass:[RTLoginViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithPresenter:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self loginPresenter]];
        }];
    }];
}

- (RTLoginPresenter *)loginPresenter {
    return [TyphoonDefinition withClass:[RTLoginPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self loginViewController]];
                          [initializer injectParameterWith:[self loginInteractor]];
                          [initializer injectParameterWith:[self loginWireframe]];
        }];
    }];
}

- (RTLoginInteractor *)loginInteractor {
    return [TyphoonDefinition withClass:[RTLoginInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:notificationCenter:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self loginPresenter]];
                          [initializer injectParameterWith:[self loginDataManager]];
                          [initializer injectParameterWith:[self.commonComponentsAssembly notificationCenter]];
        }];
    }];
}

- (RTLoginDataManager *)loginDataManager {
    return [TyphoonDefinition withClass:[RTLoginDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:client:clientCredentialsStore:tokenStore:currentUserStore:)
                      parameters:^(TyphoonMethod *initializer) {
                          [initializer injectParameterWith:[self loginInteractor]];
                          [initializer injectParameterWith:[self.clientAssembly reelTimeClient]];
                          [initializer injectParameterWith:[self.secureStoreAssembly clientCredentialsStore]];
                          [initializer injectParameterWith:[self.secureStoreAssembly tokenStore]];
                          [initializer injectParameterWith:[self.secureStoreAssembly currentUserStore]];
        }];
    }];
}


@end
