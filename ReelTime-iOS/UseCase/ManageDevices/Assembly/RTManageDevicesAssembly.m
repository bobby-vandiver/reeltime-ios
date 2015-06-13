#import "RTManageDevicesAssembly.h"

#import "RTClientAssembly.h"
#import "RTApplicationAssembly.h"

#import "RTManageDevicesWireframe.h"
#import "RTManageDevicesViewController.h"
#import "RTManageDevicesPresenter.h"

#import "RTPagedListInteractor.h"
#import "RTBrowseDevicesDataManager.h"

#import "RTRevokeClientInteractor.h"
#import "RTRevokeClientDataManager.h"

@implementation RTManageDevicesAssembly

- (RTManageDevicesWireframe *)manageDevicesWireframe {
    return [TyphoonDefinition withClass:[RTManageDevicesWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:applicationWireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self manageDevicesViewController]];
                          [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTManageDevicesViewController *)manageDevicesViewController {
    return [TyphoonDefinition withClass:[RTManageDevicesViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithPresenter:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self manageDevicesPresenter]];
        }];
    }];
}

- (RTManageDevicesPresenter *)manageDevicesPresenter {
    return [TyphoonDefinition withClass:[RTManageDevicesPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithView:browseDevicesInteractor:revokeClientInteractor:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self manageDevicesViewController]];
                          [method injectParameterWith:[self browseDevicesInteractor]];
                          [method injectParameterWith:[self revokeClientInteractor]];
        }];
    }];
}

- (RTPagedListInteractor *)browseDevicesInteractor {
    return [TyphoonDefinition withClass:[RTPagedListInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self manageDevicesPresenter]];
            [method injectParameterWith:[self browseDevicesDataManager]];
        }];
    }];
}

- (RTBrowseDevicesDataManager *)browseDevicesDataManager {
    return [TyphoonDefinition withClass:[RTBrowseDevicesDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

- (RTRevokeClientInteractor *)revokeClientInteractor {
    return [TyphoonDefinition withClass:[RTRevokeClientInteractor class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithDelegate:dataManager:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self manageDevicesPresenter]];
            [method injectParameterWith:[self revokeClientDataManager]];
        }];
    }];
}

- (RTRevokeClientDataManager *)revokeClientDataManager {
    return [TyphoonDefinition withClass:[RTRevokeClientDataManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClient:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.clientAssembly reelTimeClient]];
        }];
    }];
}

@end
