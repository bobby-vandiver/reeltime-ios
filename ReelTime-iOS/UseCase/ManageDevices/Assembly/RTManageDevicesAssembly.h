#import "TyphoonAssembly.h"

@class RTClientAssembly;
@class RTServiceAssembly;

@class RTLoginAssembly;
@class RTApplicationAssembly;

@class RTManageDevicesWireframe;
@class RTManageDevicesViewController;
@class RTManageDevicesPresenter;

@class RTPagedListInteractor;
@class RTBrowseDevicesDataManager;

@class RTRevokeClientInteractor;
@class RTRevokeClientDataManager;

@interface RTManageDevicesAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTServiceAssembly *serviceAssembly;

@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTManageDevicesWireframe *)manageDevicesWireframe;

- (RTManageDevicesViewController *)manageDevicesViewController;

- (RTManageDevicesPresenter *)manageDevicesPresenter;

- (RTPagedListInteractor *)browseDevicesInteractor;

- (RTBrowseDevicesDataManager *)browseDevicesDataManager;

- (RTRevokeClientInteractor *)revokeClientInteractor;

- (RTRevokeClientDataManager *)revokeClientDataManager;

@end
