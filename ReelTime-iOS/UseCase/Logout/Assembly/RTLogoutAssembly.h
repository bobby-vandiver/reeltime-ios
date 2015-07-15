#import "TyphoonAssembly.h"

@class RTClientAssembly;
@class RTSecureStoreAssembly;

@class RTLoginAssembly;
@class RTAccountSettingsAssembly;

@class RTApplicationAssembly;

@class RTLogoutWireframe;
@class RTLogoutPresenter;
@class RTLogoutInteractor;
@class RTLogoutDataManager;

@interface RTLogoutAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;

@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;
@property (nonatomic, strong, readonly) RTAccountSettingsAssembly *accountSettingsAssembly;

@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTLogoutWireframe *)logoutWireframe;

- (RTLogoutPresenter *)logoutPresenter;

- (RTLogoutInteractor *)logoutInteractor;

- (RTLogoutDataManager *)logoutDataManager;

@end
