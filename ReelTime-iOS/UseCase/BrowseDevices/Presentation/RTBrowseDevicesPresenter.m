#import "RTBrowseDevicesPresenter.h"
#import "RTBrowseDevicesView.h"

#import "RTClient.h"
#import "RTClientDescription.h"

@interface RTBrowseDevicesPresenter ()

@property id<RTBrowseDevicesView> view;

@end

@implementation RTBrowseDevicesPresenter

- (instancetype)initWithView:(id<RTBrowseDevicesView>)view
                  interactor:(RTPagedListInteractor *)interactor {
    self = [super initWithDelegate:self interactor:interactor];
    if (self) {
        self.view = view;
    }
    return self;
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
