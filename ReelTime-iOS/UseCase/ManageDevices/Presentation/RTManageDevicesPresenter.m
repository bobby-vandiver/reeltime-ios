#import "RTManageDevicesPresenter.h"

#import "RTManageDevicesView.h"
#import "RTManageDevicesWireframe.h"

#import "RTRevokeClientInteractor.h"

#import "RTClient.h"
#import "RTClientDescription.h"

#import "RTRevokeClientError.h"
#import "RTLogging.h"

@interface RTManageDevicesPresenter ()

@property id<RTManageDevicesView> view;
@property RTManageDevicesWireframe *wireframe;
@property RTRevokeClientInteractor *revokeClientInteractor;

@end

@implementation RTManageDevicesPresenter

- (instancetype)initWithView:(id<RTManageDevicesView>)view
                   wireframe:(RTManageDevicesWireframe *)wireframe
     browseDevicesInteractor:(RTPagedListInteractor *)browseDeviceInteractor
      revokeClientInteractor:(RTRevokeClientInteractor *)revokeClientInteractor {

    self = [super initWithDelegate:self interactor:browseDeviceInteractor];
    if (self) {
        self.view = view;
        self.wireframe = wireframe;
        self.revokeClientInteractor = revokeClientInteractor;
    }
    return self;
}

- (void)requestedRevocationForClientWithClientId:(NSString *)clientId {
    [self.revokeClientInteractor revokeClientWithClientId:clientId];
}

- (void)clientRevocationSucceededForClientWithClientId:(NSString *)clientId
                                         currentClient:(BOOL)currentClient {
    [self removeClientWithClientId:clientId];
    
    if (currentClient) {
        [self.wireframe presentLoginInterface];
    }
}

- (void)clientRevocationFailedForClientWithClientId:(NSString *)clientId
                                             errors:(NSArray *)errors {
    for (NSError *error in errors) {
        if ([error.domain isEqual:RTRevokeClientErrorDomain] && error.code == RTRevokeClientErrorUnknownClient) {
            [self.view showErrorMessage:@"Cannot revoke an unknown client"];
            [self removeClientWithClientId:clientId];
        }
        else {
            DDLogWarn(@"Unexpected client revocation error: %@", error);
        }
    }
}

- (void)removeClientWithClientId:(NSString *)clientId {
    NSIndexSet *indexes = [self.items indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[RTClient class]]) {
            RTClient *client = (RTClient *)obj;
            return [client.clientId isEqual:clientId];
        }
        return NO;
    }];
    
    if (indexes.count > 0) {
        [self.items removeObjectsAtIndexes:indexes];
        [self.view clearClientDescriptionForClientId:clientId];
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
