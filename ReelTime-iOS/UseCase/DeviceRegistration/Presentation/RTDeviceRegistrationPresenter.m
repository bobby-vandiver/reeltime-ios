#import "RTDeviceRegistrationPresenter.h"
#import "RTDeviceRegistrationView.h"
#import "RTDeviceRegistrationInteractor.h"
#import "RTDeviceRegistrationWireframe.h"

#import "RTDeviceRegistrationError.h"
#import "RTLogging.h"

@interface RTDeviceRegistrationPresenter ()

@property id<RTDeviceRegistrationView> view;
@property RTDeviceRegistrationInteractor *interactor;
@property (weak) RTDeviceRegistrationWireframe *wireframe;

@end

@implementation RTDeviceRegistrationPresenter

- (instancetype)initWithView:(id<RTDeviceRegistrationView>)view
                  interactor:(RTDeviceRegistrationInteractor *)interactor
                   wireframe:(RTDeviceRegistrationWireframe *)wireframe {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        self.wireframe = wireframe;
    }
    return self;
}

+ (NSDictionary *)deviceRegistrationCodeToErrorMessageMap {
    return @{
             @(RTDeviceRegistrationErrorMissingUsername): @"Username is required",
             @(RTDeviceRegistrationErrorMissingPassword): @"Password is required",
             @(RTDeviceRegistrationErrorMissingClientName): @"Client name is required",
             @(RTDeviceRegistrationErrorInvalidCredentials): @"Invalid username or password",
             @(RTDeviceRegistrationErrorUnableToStoreClientCredentials): @"This device was registered but a problem occurred while completing the registration. Please register under a different name or unregister the current device from a different device and try again.",
             @(RTDeviceRegistrationErrorServiceUnavailable): @"Unable to register a device at this time. Please try again shortly."
             };
}

- (void)requestedDeviceRegistrationWithClientName:(NSString *)clientName
                                         username:(NSString *)username
                                         password:(NSString *)password {

    [self.interactor registerDeviceWithClientName:clientName username:username password:password];
}

- (void)deviceRegistrationSucceeded {
    [self.wireframe presentLoginInterface];
}

- (void)deviceRegistrationFailedWithErrors:(NSArray *)errors {
    NSDictionary *messages = [RTDeviceRegistrationPresenter deviceRegistrationCodeToErrorMessageMap];
    
    for (NSError *error in errors) {
        if ([error.domain isEqual:RTDeviceRegistrationErrorDomain]) {

            NSInteger code = error.code;
            NSString *message = messages[@(code)];
            
            if (message) {
                [self presentErrorMessage:message forCode:code];
            }
        }
        else {
            DDLogWarn(@"Encountered non-device registration error = %@", error);
        }
    }
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(RTDeviceRegistrationError)code {
    switch (code) {
        case RTDeviceRegistrationErrorMissingUsername:
            [self.view showValidationErrorMessage:message forField:RTDeviceRegistrationViewFieldUsername];
            break;
            
        case RTDeviceRegistrationErrorMissingPassword:
            [self.view showValidationErrorMessage:message forField:RTDeviceRegistrationViewFieldPassword];
            break;
            
        case RTDeviceRegistrationErrorMissingClientName:
            [self.view showValidationErrorMessage:message forField:RTDeviceRegistrationViewFieldClientName];
            break;
            
        case RTDeviceRegistrationErrorInvalidCredentials:
        case RTDeviceRegistrationErrorUnableToStoreClientCredentials:
        case RTDeviceRegistrationErrorServiceUnavailable:
            [self.view showErrorMessage:message];
            break;
            
        default:
            break;
    }
}

@end
