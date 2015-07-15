#import "RTLogoutPresenter.h"

#import "RTLogoutView.h"
#import "RTLogoutInteractor.h"
#import "RTLogoutWireframe.h"

@interface RTLogoutPresenter ()

@property id<RTLogoutView> view;
@property RTLogoutInteractor *interactor;
@property RTLogoutWireframe *wireframe;

@end

@implementation RTLogoutPresenter

- (instancetype)initWithView:(id<RTLogoutView>)view
                  interactor:(RTLogoutInteractor *)interactor
                   wireframe:(RTLogoutWireframe *)wireframe {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        self.wireframe = wireframe;
    }
    return self;
}

- (void)requestedLogout {
    [self.interactor logout];
}

- (void)logoutSucceeded {
    [self.wireframe presentLoginInterface];
}

- (void)logoutFailed {
    [self.view showErrorMessage:@"Logout failed!"];
}

@end
