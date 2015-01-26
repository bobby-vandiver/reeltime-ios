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

+ (NSDictionary *)registrationErrorCodeToErrorMessageMap {
    return @{
             @(AccountRegistrationMissingUsername): @"Username is required",
             @(AccountRegistrationInvalidUsername): @"Username must be 2-15 alphanumeric characters",
             @(AccountRegistrationUsernameIsUnavailable): @"Username is unavailable",
             
             @(AccountRegistrationMissingPassword): @"Password is required",
             @(AccountRegistrationInvalidPassword): @"Password must be at least 6 characters",
             
             @(AccountRegistrationMissingConfirmationPassword): @"Confirmation password is required",
             @(AccountRegistrationConfirmationPasswordDoesNotMatch): @"Password and confirmation password must match",
             
             @(AccountRegistrationMissingEmail): @"Email is required",
             @(AccountRegistrationInvalidEmail): @"Email is not a valid email address",
             
             @(AccountRegistrationMissingDisplayName): @"Display name is required",
             @(AccountRegistrationInvalidDisplayName): @"Display name must be 2-20 alphanumeric or space characters",
             
             @(AccountRegistrationMissingClientName): @"Client name is required",
             @(AccountRegistrationRegistrationServiceUnavailable): @"Unable to register at this time. Please try again."
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

- (void)registrationWithAutoLoginSucceeded {
    [self.wireframe presentPostAutoLoginInterface];
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
    error.code == AccountRegistrationUnableToAssociateClientWithDevice;
}

- (void)registrationFailedWithErrors:(NSArray *)errors {
    for (NSError *error in errors) {
        if ([error.domain isEqual:RTAccountRegistrationErrorDomain]) {
            [self showErrorMessageForRegistrationErrorCode:error.code];
        }
    }
}

- (void)showErrorMessageForRegistrationErrorCode:(RTAccountRegistrationErrors)code {
    NSDictionary *messages = [RTAccountRegistrationPresenter registrationErrorCodeToErrorMessageMap];
    NSString *message = messages[@(code)];
    if (message) {
        [self.view showErrorMessage:message];
    }
}

@end
