#import "RTDeviceRegistrationAssembly.h"

#import "RTClientAssembly.h"
#import "RTSecureStoreAssembly.h"

#import "RTLoginAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTDeviceRegistrationWireframe.h"
#import "RTDeviceRegistrationViewController.h"
#import "RTDeviceRegistrationPresenter.h"
#import "RTDeviceRegistrationInteractor.h"
#import "RTDeviceRegistrationDataManager.h"

@implementation RTDeviceRegistrationAssembly

- (RTDeviceRegistrationWireframe *)deviceRegistrationWireframe {
    return [TyphoonDefinition withClass:[RTDeviceRegistrationWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:loginWireframe:applicationWireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self deviceRegistrationViewController]];
                          [method injectParameterWith:[self.loginAssembly loginWireframe]];
                          [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTDeviceRegistrationViewController *)deviceRegistrationViewController {
    return [TyphoonDefinition withClass:[RTDeviceRegistrationViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithPresenter:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self deviceRegistrationPresenter]];
        }];
    }];
}

- (RTDeviceRegistrationPresenter *)deviceRegistrationPresenter {
    return [TyphoonDefinition withClass:[RTDeviceRegistrationPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:interactor:wireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self deviceRegistrationViewController]];
                          [method injectParameterWith:[self deviceRegistrationInteractor]];
                          [method injectParameterWith:[self deviceRegistrationWireframe]];
        }];
    }];
}

- (RTDeviceRegistrationInteractor *)deviceRegistrationInteractor {
    return [TyphoonDefinition withClass:[RTDeviceRegistrationInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self deviceRegistrationPresenter]];
                          [method injectParameterWith:[self deviceRegistrationDataManager]];
        }];
    }];
}

- (RTDeviceRegistrationDataManager *)deviceRegistrationDataManager {
    return [TyphoonDefinition withClass:[RTDeviceRegistrationDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:client:clientCredentialsStore:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self deviceRegistrationInteractor]];
                          [method injectParameterWith:[self.clientAssembly reelTimeClient]];
                          [method injectParameterWith:[self.secureStoreAssembly clientCredentialsStore]];
        }];
    }];
}

@end
