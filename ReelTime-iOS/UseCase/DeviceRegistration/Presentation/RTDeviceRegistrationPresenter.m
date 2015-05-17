#import "RTDeviceRegistrationPresenter.h"

#import "RTDeviceRegistrationView.h"
#import "RTDeviceRegistrationInteractor.h"
#import "RTDeviceRegistrationWireframe.h"

#import "RTErrorCodeToErrorMessagePresenter.h"
#import "RTDeviceRegistrationErrorCodeToErrorMessageMapping.h"

#import "RTDeviceRegistrationError.h"
#import "RTLogging.h"

@interface RTDeviceRegistrationPresenter ()

@property id<RTDeviceRegistrationView> view;
@property RTDeviceRegistrationInteractor *interactor;
@property (weak) RTDeviceRegistrationWireframe *wireframe;
@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

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
        
        RTDeviceRegistrationErrorCodeToErrorMessageMapping *mapping = [[RTDeviceRegistrationErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
    }
    return self;
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
    [self.errorPresenter presentErrors:errors];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
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
