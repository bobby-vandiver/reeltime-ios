#import "RTPagedListPresenter.h"
#import "RTPagedListPresenterDelegate.h"
#import "RTRevokeClientInteractorDelegate.h"

@protocol RTManageDevicesView;

@class RTPagedListInteractor;
@class RTRevokeClientInteractor;

@interface RTManageDevicesPresenter : RTPagedListPresenter <RTPagedListPresenterDelegate, RTRevokeClientInteractorDelegate>

- (instancetype)initWithView:(id<RTManageDevicesView>)view
     browseDevicesInteractor:(RTPagedListInteractor *)browseDeviceInteractor
      revokeClientInteractor:(RTRevokeClientInteractor *)revokeClientInteractor;

- (void)requestedRevocationForClientWithClientId:(NSString *)clientId;

@end
