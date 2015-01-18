#import "RTLoginPresenter.h"
#import "RTLoginInteractor.h"
#import "RTLoginWireframe.h"

#import "RTErrorFactory.h"

@interface RTLoginPresenter ()

@property id<RTLoginView> view;
@property RTLoginInteractor *interactor;
@property RTLoginWireframe *wireframe;

@end

@implementation RTLoginPresenter

- (instancetype)initWithView:(id<RTLoginView>)view
                  interactor:(RTLoginInteractor *)interactor
                   wireframe:(RTLoginWireframe *)wireframe {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        self.wireframe = wireframe;
    }
    return self;
}

- (void)requestedLoginWithUsername:(NSString *)username
                           password:(NSString *)password {
    [self.interactor loginWithUsername:username password:password];
}

- (void)loginSucceeded {
    [self.wireframe presentPostLoginInterface];
}

- (void)loginFailedWithError:(NSError *)error {
    NSString *message = @"An unknown error occurred";
    
    if ([error.domain isEqualToString:RTLoginErrorDomain]) {
        if (error.code == LoginMissingUsername) {
            message = @"Username is required";
        }
        else if (error.code == LoginMissingPassword) {
            message = @"Password is required";
        }
        else if (error.code == LoginInvalidCredentials) {
            message = @"Invalid username or password";
        }
        else if (error.code == LoginUnknownClient) {
            [self.wireframe presentDeviceRegistrationInterface];
            return;
        }
    }
    
    [self.view showErrorMessage:message];
}

@end
