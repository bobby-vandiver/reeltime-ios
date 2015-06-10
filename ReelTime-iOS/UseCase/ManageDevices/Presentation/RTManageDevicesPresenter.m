#import "RTManageDevicesPresenter.h"

#import "RTManageDevicesView.h"
#import "RTRevokeClientInteractor.h"

#import "RTClient.h"
#import "RTClientDescription.h"

@interface RTManageDevicesPresenter ()

@property id<RTManageDevicesView> view;
@property RTRevokeClientInteractor *revokeClientInteractor;

@end

@implementation RTManageDevicesPresenter

- (instancetype)initWithView:(id<RTManageDevicesView>)view
     browseDevicesInteractor:(RTPagedListInteractor *)browseDeviceInteractor
      revokeClientInteractor:(RTRevokeClientInteractor *)revokeClientInteractor {

    self = [super initWithDelegate:self interactor:browseDeviceInteractor];
    if (self) {
        self.view = view;
        self.revokeClientInteractor = revokeClientInteractor;
    }
    return self;
}

- (void)requestedRevocationForClientWithClientId:(NSString *)clientId {
    [self.revokeClientInteractor revokeClientWithClientId:clientId];
}

- (void)clientRevocationSucceeded {
    
}

- (void)clientRevocationFailedWithErrors:(NSArray *)errors {
    
}

- (void)clearPresentedItems {
    [self.view clearClientDescriptions];
}

- (void)presentItem:(RTClient *)client {
    RTClientDescription *description = [RTClientDescription clientDescriptionWithClientId:client.clientId
                                                                               clientName:client.clientName];
    [self.view showClientDescription:description];
}

@end
