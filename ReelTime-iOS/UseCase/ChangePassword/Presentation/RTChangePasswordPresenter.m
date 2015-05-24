#import "RTChangePasswordPresenter.h"
#import "RTChangePasswordView.h"
#import "RTChangePasswordInteractor.h"
#import "RTChangePasswordWireframe.h"

@interface RTChangePasswordPresenter ()

@property id<RTChangePasswordView> view;
@property RTChangePasswordInteractor *interactor;
@property RTChangePasswordWireframe *wireframe;

@end

@implementation RTChangePasswordPresenter

- (instancetype)initWithView:(id<RTChangePasswordView>)view
                  interactor:(RTChangePasswordInteractor *)interactor
                   wireframe:(RTChangePasswordWireframe *)wireframe {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        self.wireframe = wireframe;
    }
    return self;
}

- (void)requestedPasswordChangeWithPassword:(NSString *)password
                       confirmationPassword:(NSString *)confirmationPassword {
    [self.interactor changePassword:password confirmationPassword:confirmationPassword];
}

- (void)changePasswordSucceeded {
    [self.view showMessage:@"Password change succeeded"];
}

- (void)changePasswordFailedWithErrors:(NSArray *)errors {
    
}

@end
