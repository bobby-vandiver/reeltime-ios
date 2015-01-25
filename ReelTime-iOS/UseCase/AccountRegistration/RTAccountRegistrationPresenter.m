#import "RTAccountRegistrationPresenter.h"

#import "RTAccountRegistrationView.h"
#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationWireframe.h"

#import "RTAccountRegistration.h"

#import "RTAccountRegistrationErrors.h"
#import "RTLoginErrors.h"

@interface RTAccountRegistrationPresenter ()

@property id<RTAccountRegistrationView> view;
@property RTAccountRegistrationInteractor *interactor;
@property RTAccountRegistrationWireframe *wireframe;

@end

@implementation RTAccountRegistrationPresenter

- (instancetype)initWithView:(id<RTAccountRegistrationView>)view
                  interactor:(RTAccountRegistrationInteractor *)interactor
                   wireframe:(RTAccountRegistrationWireframe *)wireframe {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        self.wireframe = wireframe;
    }
    return self;
}

- (void)requestedAccountRegistrationWithUsername:(NSString *)username
                                        password:(NSString *)password
                            confirmationPassword:(NSString *)confirmationPassword
                                           email:(NSString *)email
                                     displayName:(NSString *)displayName
                                      clientName:(NSString *)clientName {
    RTAccountRegistration *registration = [[RTAccountRegistration alloc] initWithUsername:username
                                                                                 password:password
                                                                     confirmationPassword:confirmationPassword
                                                                                    email:email
                                                                              displayName:displayName
                                                                               clientName:clientName];
    [self.interactor registerAccount:registration];
}

- (void)registrationWithAutoLoginSucceeded {
    [self.wireframe presentPostAutoLoginInterface];
}

- (void)registrationWithAutoLoginFailedWithError:(NSError *)error {
    if ([self failedToAssociateClientWithDevice:error]) {
        NSString *message = @"Account was registered but we were unable to associate your device with your account."
                            @"Please register your device separately.";
        
        [self.view showErrorMessages:@[message]];
        [self.wireframe presentDeviceRegistrationInterface];
    }
    else {
        NSString *message = @"Account was registered but we were unable to log you in automatically."
                            @"Please login.";
        
        [self.view showErrorMessages:@[message]];
        [self.wireframe presentLoginInterface];
    }
}

- (BOOL)failedToAssociateClientWithDevice:(NSError *)error {
    return [error.domain isEqualToString:RTAccountRegistrationErrorDomain] &&
    error.code == AccountRegistrationUnableToAssociateClientWithDevice;
}

- (void)registrationFailedWithErrors:(NSArray *)errors {
}

@end
