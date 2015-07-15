#import "TyphoonAssembly.h"

@class RTChangeDisplayNameAssembly;
@class RTChangePasswordAssembly;

@class RTConfirmAccountAssembly;
@class RTManageDevicesAssembly;

@class RTLogoutAssembly;
@class RTApplicationAssembly;

@class RTAccountSettingsWireframe;
@class RTAccountSettingsViewController;
@class RTAccountSettingsPresenter;

@interface RTAccountSettingsAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTChangeDisplayNameAssembly *changeDisplayNameAssembly;
@property (nonatomic, strong, readonly) RTChangePasswordAssembly *changePasswordAssembly;

@property (nonatomic, strong, readonly) RTConfirmAccountAssembly *confirmAccountAssembly;
@property (nonatomic, strong, readonly) RTManageDevicesAssembly *manageDevicesAssembly;

@property (nonatomic, strong, readonly) RTLogoutAssembly *logoutAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTAccountSettingsWireframe *)accountSettingsWireframe;

- (RTAccountSettingsViewController *)accountSettingsViewController;

- (RTAccountSettingsPresenter *)accountSettingsPresenter;

@end
