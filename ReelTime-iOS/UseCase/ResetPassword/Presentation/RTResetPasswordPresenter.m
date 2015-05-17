#import "RTResetPasswordPresenter.h"

#import "RTResetPasswordView.h"
#import "RTResetPasswordInteractor.h"
#import "RTResetPasswordWireframe.h"

#import "RTResetPasswordErrorCodeToErrorMessageMapping.h"
#import "RTErrorCodeToErrorMessagePresenter.h"

@interface RTResetPasswordPresenter ()

@property id<RTResetPasswordView> view;
@property RTResetPasswordInteractor *interactor;
@property RTResetPasswordWireframe *wireframe;
@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

@end

@implementation RTResetPasswordPresenter

- (instancetype)initWithView:(id<RTResetPasswordView>)view
                  interactor:(RTResetPasswordInteractor *)interactor
                   wireframe:(RTResetPasswordWireframe *)wireframe {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        self.wireframe = wireframe;
        
        RTResetPasswordErrorCodeToErrorMessageMapping *mapping = [[RTResetPasswordErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
    }
    return self;
}

- (void)requestedResetPasswordEmailForUsername:(NSString *)username {
    [self.interactor sendResetPasswordEmailForUsername:username];
}

- (void)requestedResetPasswordWithCode:(NSString *)code
                              username:(NSString *)username
                              password:(NSString *)password
                  confirmationPassword:(NSString *)confirmationPassword {

    [self.interactor resetPasswordForCurrentClientWithCode:code
                                                  username:username
                                                  password:password
                                      confirmationPassword:confirmationPassword];
}

- (void)requestedResetPasswordWithCode:(NSString *)code
                              username:(NSString *)username
                              password:(NSString *)password
                  confirmationPassword:(NSString *)confirmationPassword
                            clientName:(NSString *)clientName {
    
    [self.interactor resetPasswordForNewClientWithClientName:clientName
                                                        code:code
                                                    username:username
                                                    password:password
                                        confirmationPassword:confirmationPassword];
}

- (void)resetPasswordEmailSent {
    [self.view showMessage:@"Please check your email to complete the reset process"];
    [self.wireframe presentResetPasswordInterface];
}

- (void)resetPasswordEmailFailedWithErrors:(NSArray *)errors {
    
}

- (void)resetPasswordSucceeded {
    [self.wireframe presentLoginInterface];
}

- (void)resetPasswordFailedWithErrors:(NSArray *)errors {
    
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    
}

@end
