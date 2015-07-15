#import "RTLogoutAssembly.h"

#import "RTClientAssembly.h"
#import "RTSecureStoreAssembly.h"

#import "RTLoginAssembly.h"
#import "RTAccountSettingsAssembly.h"

#import "RTApplicationAssembly.h"

#import "RTLogoutWireframe.h"
#import "RTLogoutPresenter.h"
#import "RTLogoutInteractor.h"
#import "RTLogoutDataManager.h"

#import "RTLogoutView.h"
#import "RTAccountSettingsViewController.h"

@implementation RTLogoutAssembly

- (RTLogoutWireframe *)logoutWireframe {
    return [TyphoonDefinition withClass:[RTLogoutWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithLoginWireframe:applicationWireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.loginAssembly loginWireframe]];
            [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTLogoutPresenter *)logoutPresenter {
    return [TyphoonDefinition withClass:[RTLogoutPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.accountSettingsAssembly accountSettingsViewController]];
            [method injectParameterWith:[self logoutInteractor]];
            [method injectParameterWith:[self logoutWireframe]];
        }];
    }];
}

- (RTLogoutInteractor *)logoutInteractor {
    return [TyphoonDefinition withClass:[RTLogoutInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self logoutPresenter]];
            [method injectParameterWith:[self logoutDataManager]];
        }];
    }];
}

- (RTLogoutDataManager *)logoutDataManager {
    return [TyphoonDefinition withClass:[RTLogoutDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:tokenStore:currentUserStore:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.clientAssembly reelTimeClient]];
            [method injectParameterWith:[self.secureStoreAssembly tokenStore]];
            [method injectParameterWith:[self.secureStoreAssembly currentUserStore]];
        }];
    }];
}

@end
