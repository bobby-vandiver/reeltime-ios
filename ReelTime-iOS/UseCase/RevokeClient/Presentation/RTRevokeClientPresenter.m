#import "RTRevokeClientPresenter.h"

#import "RTRevokeClientView.h"
#import "RTRevokeClientInteractor.h"

@interface RTRevokeClientPresenter ()

@property id<RTRevokeClientView> view;
@property RTRevokeClientInteractor *interactor;

@end

@implementation RTRevokeClientPresenter

- (instancetype)initWithView:(id<RTRevokeClientView>)view
                  interactor:(RTRevokeClientInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
    }
    return self;
}

- (void)requestedRevocationForClientWithClientId:(NSString *)clientId {
    [self.interactor revokeClientWithClientId:clientId];
}

- (void)clientRevocationSucceeded {
    
}

- (void)clientRevocationFailedWithErrors:(NSArray *)errors {
    
}

@end
