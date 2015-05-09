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

- (void)requestedDeviceRegistration {
    [self.wireframe presentDeviceRegistrationInterface];
}

- (void)requestedAccountRegistration {
    [self.wireframe presentAccountRegistrationInterface];
}

- (void)loginSucceeded {
    [self.wireframe presentPostLoginInterface];
}

- (void)loginFailedWithErrors:(NSArray *)errors {
    [errors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self presentError:obj stop:stop];
    }];
}

- (void)presentError:(NSError *)error
                stop:(BOOL *)stop {
    if ([self unexpectedError:error]) {
        [self.view showErrorMessage:@"An unknown error occurred"];
        return;
    }
    
    if (error.code == RTLoginErrorMissingUsername) {
        [self.view showValidationErrorMessage:@"Username is required" forField:RTLoginViewFieldUsername];
    }
    else if (error.code == RTLoginErrorMissingPassword) {
        [self.view showValidationErrorMessage:@"Password is required" forField:RTLoginViewFieldPassword];
    }
    else if (error.code == RTLoginErrorInvalidCredentials) {
        [self.view showErrorMessage:@"Invalid username or password"];
    }
    else if (error.code == RTLoginErrorUnknownClient) {
        [self.wireframe presentDeviceRegistrationInterface];
        *stop = YES;
    }
}

- (BOOL)unexpectedError:(NSError *)error {
    BOOL unexpected = NO;
    
    if ([error.domain isEqualToString:RTLoginErrorDomain]) {
        NSInteger code = error.code;
        unexpected = !(code == RTLoginErrorMissingUsername || code == RTLoginErrorMissingPassword ||
                       code == RTLoginErrorInvalidCredentials || code == RTLoginErrorUnknownClient);
    }
    else {
        unexpected = YES;
    }
    
    return unexpected;
}

@end
