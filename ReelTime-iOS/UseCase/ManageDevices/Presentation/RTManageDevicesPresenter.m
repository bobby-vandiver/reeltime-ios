#import "RTManageDevicesPresenter.h"

#import "RTManageDevicesView.h"
#import "RTRevokeClientInteractor.h"

#import "RTClient.h"
#import "RTClientDescription.h"

#import "RTRevokeClientError.h"
#import "RTLogging.h"

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

- (void)clientRevocationSucceededForClientWithClientId:(NSString *)clientId {
    
}

- (void)clientRevocationFailedForClientWithClientId:(NSString *)clientId
                                             errors:(NSArray *)errors {
    for (NSError *error in errors) {
        if ([error.domain isEqual:RTRevokeClientErrorDomain] && error.code == RTRevokeClientErrorUnknownClient) {
            [self.view showErrorMessage:@"Cannot revoke an unknown client"];
        }
        else {
            DDLogWarn(@"Unexpected client revocation error: %@", error);
        }
    }
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
