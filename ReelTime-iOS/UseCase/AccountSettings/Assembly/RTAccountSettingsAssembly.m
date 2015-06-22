#import "RTAccountSettingsAssembly.h"

#import "RTChangeDisplayNameAssembly.h"
#import "RTChangePasswordAssembly.h"

#import "RTConfirmAccountAssembly.h"
#import "RTManageDevicesAssembly.h"

#import "RTApplicationAssembly.h"

#import "RTAccountSettingsWireframe.h"
#import "RTAccountSettingsViewController.h"
#import "RTAccountSettingsPresenter.h"

@implementation RTAccountSettingsAssembly

- (RTAccountSettingsWireframe *)accountSettingsWireframe {
    return [TyphoonDefinition withClass:[RTAccountSettingsWireframe class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithViewController:changeDisplayNameWireframe:changePasswordWireframe:confirmAccountWireframe:manageDevicesWireframe:applicationWireframe:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self accountSettingsViewController]];
                          [method injectParameterWith:[self.changeDisplayNameAssembly changeDisplayNameWireframe]];
                          [method injectParameterWith:[self.changePasswordAssembly changePasswordWireframe]];
                          [method injectParameterWith:[self.confirmAccountAssembly confirmAccountWireframe]];
                          [method injectParameterWith:[self.manageDevicesAssembly manageDevicesWireframe]];
                          [method injectParameterWith:[self.applicationAssembly applicationWireframe]];
        }];
    }];
}

- (RTAccountSettingsViewController *)accountSettingsViewController {
    return [TyphoonDefinition withClass:[RTAccountSettingsViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(viewControllerWithPresenter:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self accountSettingsPresenter]];
        }];
    }];
}

- (RTAccountSettingsPresenter *)accountSettingsPresenter {
    return [TyphoonDefinition withClass:[RTAccountSettingsPresenter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithWireframe:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self accountSettingsWireframe]];
        }];
    }];
}

@end
