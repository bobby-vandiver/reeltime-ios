#import "RTChangePasswordPresenter.h"
#import "RTChangePasswordView.h"
#import "RTChangePasswordInteractor.h"
#import "RTChangePasswordWireframe.h"

#import "RTErrorCodeToErrorMessagePresenter.h"
#import "RTChangePasswordErrorCodeToErrorMessageMapping.h"

#import "RTChangePasswordError.h"
#import "RTLogging.h"

@interface RTChangePasswordPresenter ()

@property id<RTChangePasswordView> view;
@property RTChangePasswordInteractor *interactor;
@property RTChangePasswordWireframe *wireframe;
@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

@end

@implementation RTChangePasswordPresenter

- (instancetype)initWithView:(id<RTChangePasswordView>)view
                  interactor:(RTChangePasswordInteractor *)interactor
                   wireframe:(RTChangePasswordWireframe *)wireframe {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        self.wireframe = wireframe;
        
        RTChangePasswordErrorCodeToErrorMessageMapping *mapping = [[RTChangePasswordErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
    }
    return self;
}

- (void)requestedPasswordChangeWithPassword:(NSString *)password
                       confirmationPassword:(NSString *)confirmationPassword {
    [self.interactor changePassword:password confirmationPassword:confirmationPassword];
}

- (void)changePasswordSucceeded {
    [self.view showMessage:@"Password change succeeded"];
}

- (void)changePasswordFailedWithErrors:(NSArray *)errors {
    [self.errorPresenter presentErrors:errors];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    switch (code) {
        case RTChangePasswordErrorMissingPassword:
        case RTChangePasswordErrorInvalidPassword:
            [self.view showValidationErrorMessage:message forField:RTChangePasswordViewFieldPassword];
            break;
            
        case RTChangePasswordErrorMissingConfirmationPassword:
            [self.view showValidationErrorMessage:message forField:RTChangePasswordViewFieldConfirmationPassword];
            break;
            
        case RTChangePasswordErrorConfirmationPasswordDoesNotMatch:
            [self.view showErrorMessage:message];
            break;
            
        default:
            DDLogWarn(@"Unknown change password error code %ld", (long)code);
            break;
    }
}

@end
