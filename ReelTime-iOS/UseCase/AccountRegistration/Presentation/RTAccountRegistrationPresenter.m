#import "RTAccountRegistrationPresenter.h"

#import "RTAccountRegistrationView.h"
#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationWireframe.h"

#import "RTAccountRegistration.h"

#import "RTAccountRegistrationError.h"
#import "RTLoginError.h"

@interface RTAccountRegistrationPresenter ()

@property id<RTAccountRegistrationView> view;
@property RTAccountRegistrationInteractor *interactor;
@property (weak) RTAccountRegistrationWireframe *wireframe;

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

+ (NSDictionary *)registrationErrorCodeToErrorMessageMap {
    return @{
             @(RTAccountRegistrationErrorMissingUsername): @"Username is required",
             @(RTAccountRegistrationErrorInvalidUsername): @"Username must be 2-15 alphanumeric characters",
             @(RTAccountRegistrationErrorUsernameIsUnavailable): @"Username is unavailable",
             
             @(RTAccountRegistrationErrorMissingPassword): @"Password is required",
             @(RTAccountRegistrationErrorInvalidPassword): @"Password must be at least 6 characters",
             
             @(RTAccountRegistrationErrorMissingConfirmationPassword): @"Confirmation password is required",
             @(RTAccountRegistrationErrorConfirmationPasswordDoesNotMatch): @"Password and confirmation password must match",
             
             @(RTAccountRegistrationErrorMissingEmail): @"Email is required",
             @(RTAccountRegistrationErrorInvalidEmail): @"Email is not a valid email address",
             @(RTAccountRegistrationErrorEmailIsUnavailable): @"Email is unavailable",
             
             @(RTAccountRegistrationErrorMissingDisplayName): @"Display name is required",
             @(RTAccountRegistrationErrorInvalidDisplayName): @"Display name must be 2-20 alphanumeric or space characters",
             
             @(RTAccountRegistrationErrorMissingClientName): @"Client name is required",
             @(RTAccountRegistrationErrorRegistrationServiceUnavailable): @"Unable to register at this time. Please try again."
             };
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
    NSDictionary *messages = [RTAccountRegistrationPresenter registrationErrorCodeToErrorMessageMap];

    for (NSError *error in errors) {
        if ([error.domain isEqual:RTAccountRegistrationErrorDomain]) {
            
            NSInteger code = error.code;
            NSString *message = messages[@(code)];

            if (message) {
                [self presentErrorMessage:message forCode:code];
            }
        }
    }
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(RTAccountRegistrationError)code {
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
