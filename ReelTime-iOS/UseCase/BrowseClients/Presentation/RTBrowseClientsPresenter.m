#import "RTBrowseClientsPresenter.h"
#import "RTBrowseClientsView.h"

#import "RTClient.h"
#import "RTClientDescription.h"

@interface RTBrowseClientsPresenter ()

@property id<RTBrowseClientsView> view;

@end

@implementation RTBrowseClientsPresenter

- (instancetype)initWithView:(id<RTBrowseClientsView>)view
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
