#import "RTLoginPresenter.h"
#import "RTLoginView.h"
#import "RTLoginInteractor.h"
#import "RTLoginWireframe.h"

#import "RTLoginPresentationModel.h"
#import "RTConditionalMessage.h"

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
    RTLoginPresentationModel *presentationModel = [[RTLoginPresentationModel alloc] init];

    for (NSError *error in errors) {
        if ([error.domain isEqualToString:RTLoginErrorDomain]) {
            if (error.code == RTLoginErrorMissingUsername) {
                presentationModel.validUsername = [RTConditionalMessage falseWithMessage:@"Username is required"];
            }
            else if (error.code == RTLoginErrorMissingPassword) {
                presentationModel.validPassword = [RTConditionalMessage falseWithMessage:@"Password is required"];
            }
            else if (error.code == RTLoginErrorInvalidCredentials) {
                presentationModel.validCredentials = [RTConditionalMessage falseWithMessage:@"Invalid username or password"];
            }
            else if (error.code == RTLoginErrorUnknownClient) {
                [self.wireframe presentDeviceRegistrationInterface];
                return;
            }
            else {
                presentationModel.unknownErrorOccurred = [RTConditionalMessage trueWithMessage:@"An unknown error occurred"];
            }
        }
        else {
            presentationModel.unknownErrorOccurred = [RTConditionalMessage trueWithMessage:@"An unknown error occurred"];
        }
    }

    [self.view updateWithPresentationModel:presentationModel];
}

@end
