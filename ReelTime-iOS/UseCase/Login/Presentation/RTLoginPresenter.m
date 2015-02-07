#import "RTLoginPresenter.h"
#import "RTLoginView.h"
#import "RTLoginInteractor.h"
#import "RTLoginWireframe.h"

#import "RTErrorFactory.h"

@interface RTLoginPresenter ()

@property id<RTLoginView> view;
@property RTLoginInteractor *interactor;
@property (weak) RTLoginWireframe *wireframe;

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

- (void)requestedAccountRegistration {
    [self.wireframe presentAccountRegistrationInterface];
}

- (void)loginSucceeded {
    [self.wireframe presentPostLoginInterface];
}

- (void)loginFailedWithErrors:(NSArray *)errors {
    NSString *message = @"An unknown error occurred";

    for (NSError *error in errors) {
        if ([error.domain isEqualToString:RTLoginErrorDomain]) {
            if (error.code == RTLoginErrorMissingUsername) {
                message = @"Username is required";
            }
            else if (error.code == RTLoginErrorMissingPassword) {
                message = @"Password is required";
            }
            else if (error.code == RTLoginErrorInvalidCredentials) {
                message = @"Invalid username or password";
            }
            else if (error.code == RTLoginErrorUnknownClient) {
                [self.wireframe presentDeviceRegistrationInterface];
                break;
            }
        }
        [self.view showErrorMessage:message];
    }
}

@end