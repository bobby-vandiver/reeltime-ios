#import "RTAccountRegistrationPresenter.h"

#import "RTAccountRegistrationView.h"
#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationWireframe.h"

#import "RTErrorCodeToErrorMessagePresenter.h"
#import "RTAccountRegistrationErrorCodeToErrorMessageMapping.h"

#import "RTAccountRegistration.h"

#import "RTAccountRegistrationError.h"
#import "RTLoginError.h"

@interface RTAccountRegistrationPresenter ()

@property id<RTAccountRegistrationView> view;
@property RTAccountRegistrationInteractor *interactor;
@property (weak) RTAccountRegistrationWireframe *wireframe;
@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

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
        
        RTAccountRegistrationErrorCodeToErrorMessageMapping *mapping = [[RTAccountRegistrationErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
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

- (void)registrationWithAutoLoginFailedWithError:(NSError *)error {
    if ([self failedToAssociateClientWithDevice:error]) {
        NSString *message = @"Account was registered but we were unable to associate your device with your account."
                            @"Please register your device separately.";
        
        [self.view showErrorMessage:message];
        [self.wireframe presentDeviceRegistrationInterface];
    }
    else {
        NSString *message = @"Account was registered but we were unable to log you in automatically."
                            @"Please login.";
        
        [self.view showErrorMessage:message];
        [self.wireframe presentLoginInterface];
    }
}

- (BOOL)failedToAssociateClientWithDevice:(NSError *)error {
    return [error.domain isEqualToString:RTAccountRegistrationErrorDomain] &&
    error.code == RTAccountRegistrationErrorUnableToAssociateClientWithDevice;
}

- (void)registrationFailedWithErrors:(NSArray *)errors {
    [self.errorPresenter presentErrors:errors];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    switch (code) {
        case RTAccountRegistrationErrorMissingUsername:
        case RTAccountRegistrationErrorInvalidUsername:
        case RTAccountRegistrationErrorUsernameIsUnavailable:
            [self.view showValidationErrorMessage:message forField:RTAccountRegistrationViewFieldUsername];
            break;
            
        case RTAccountRegistrationErrorMissingPassword:
        case RTAccountRegistrationErrorInvalidPassword:
            [self.view showValidationErrorMessage:message forField:RTAccountRegistrationViewFieldPassword];
            break;
            
        case RTAccountRegistrationErrorMissingConfirmationPassword:
            [self.view showValidationErrorMessage:message forField:RTAccountRegistrationViewFieldConfirmationPassword];
            break;
            
        case RTAccountRegistrationErrorMissingEmail:
        case RTAccountRegistrationErrorInvalidEmail:
        case RTAccountRegistrationErrorEmailIsUnavailable:
            [self.view showValidationErrorMessage:message forField:RTAccountRegistrationViewFieldEmail];
            break;
            
        case RTAccountRegistrationErrorMissingClientName:
            [self.view showValidationErrorMessage:message forField:RTAccountRegistrationViewFieldClientName];
            break;
            
        case RTAccountRegistrationErrorMissingDisplayName:
        case RTAccountRegistrationErrorInvalidDisplayName:
            [self.view showValidationErrorMessage:message forField:RTAccountRegistrationViewFieldDisplayName];
            break;

        case RTAccountRegistrationErrorConfirmationPasswordDoesNotMatch:
        case RTAccountRegistrationErrorRegistrationServiceUnavailable:
            [self.view showErrorMessage:message];
            break;
            
        default:
            break;
    }
}

- (void)loginSucceeded {
    [self.wireframe presentPostAutoLoginInterface];
}

- (void)loginFailedWithErrors:(NSArray *)errors {
    if ([errors count] > 0) {
        NSError *error = [errors objectAtIndex:0];
        [self registrationWithAutoLoginFailedWithError:error];
    }
}

@end
