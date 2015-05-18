#import "RTTestCommon.h"

#import "RTResetPasswordPresenter.h"

#import "RTResetPasswordView.h"
#import "RTResetPasswordInteractor.h"
#import "RTResetPasswordWireframe.h"

#import "RTResetPasswordError.h"
#import "RTErrorFactory.h"

SpecBegin(RTResetPasswordPresenter)

describe(@"reset password presenter", ^{
    
    __block RTResetPasswordPresenter *presenter;
    __block id<RTResetPasswordView> view;
    
    __block RTResetPasswordInteractor *interactor;
    __block RTResetPasswordWireframe *wireFrame;
    
    NSString *const resetCode = @"reset";
    
    beforeEach(^{
        wireFrame = mock([RTResetPasswordWireframe class]);
        interactor = mock([RTResetPasswordInteractor class]);

        view = mockProtocol(@protocol(RTResetPasswordView));
        
        presenter = [[RTResetPasswordPresenter alloc] initWithView:view
                                                        interactor:interactor
                                                         wireframe:wireFrame];
    });
    
    describe(@"requested reset password email", ^{
        it(@"should should pass username to interactor", ^{
            [presenter requestedResetPasswordEmailForUsername:username];
            [verify(interactor) sendResetPasswordEmailForUsername:username];
        });
    });
    
    describe(@"requested password reset", ^{

        context(@"registered client", ^{
            it(@"should pass info to interactor", ^{
                [presenter requestedResetPasswordWithCode:resetCode username:username password:password confirmationPassword:password];
                [verify(interactor) resetPasswordForCurrentClientWithCode:resetCode username:username password:password confirmationPassword:password];
            });
        });
        
        context(@"new client", ^{
            it(@"should pass info to interactor", ^{
                [presenter requestedResetPasswordWithCode:resetCode username:username password:password confirmationPassword:password clientName:clientName];
                [verify(interactor) resetPasswordForNewClientWithClientName:clientName code:resetCode username:username password:password confirmationPassword:password];
            });
        });
    });
    
    describe(@"reset password email sent successfully", ^{
        it(@"should route to the reset password interface", ^{
            [presenter resetPasswordEmailSent];
            [verify(view) showMessage:@"Please check your email to complete the reset process"];
            [verify(wireFrame) presentResetPasswordInterface];
        });
    });
    
    describe(@"reset password successfully", ^{
        it(@"should route to the login interface", ^{
            [presenter resetPasswordSucceeded];
            [verify(wireFrame) presentLoginInterface];
        });
    });
    
    describe(@"reset password failure message", ^{
        
        void (^verifyValidationErrorMessageIsShown)(NSString *message, RTResetPasswordError code, RTResetPasswordViewField field) =
        ^(NSString *message, RTResetPasswordError code, RTResetPasswordViewField field) {
            NSError *error = [RTErrorFactory resetPasswordErrorWithCode:code];
            
            [presenter resetPasswordEmailFailedWithErrors:@[error]];
            [verify(view) showValidationErrorMessage:message forField:field];
            
            [verify(view) reset];
            
            [presenter resetPasswordFailedWithErrors:@[error]];
            [verify(view) showValidationErrorMessage:message forField:field];
            
            [verify(view) reset];
        };
        
        void (^verifyErrorMessageIsShown)(NSString *message, RTResetPasswordError code) =
        ^(NSString *message, RTResetPasswordError code) {
            NSError *error = [RTErrorFactory resetPasswordErrorWithCode:code];
            
            [presenter resetPasswordEmailFailedWithErrors:@[error]];
            [verify(view) showErrorMessage:message];

            [verify(view) reset];

            [presenter resetPasswordFailedWithErrors:@[error]];
            [verify(view) showErrorMessage:message];
            
            [verify(view) reset];
        };
        
        it(@"missing code", ^{
            verifyValidationErrorMessageIsShown(@"Reset code is required",
                                                RTResetPasswordErrorMissingResetCode,
                                                RTResetPasswordViewFieldResetCode);
        });
        
        it(@"invalid code", ^{
            verifyErrorMessageIsShown(@"Reset code is invalid",
                                      RTResetPasswordErrorInvalidResetCode);
        });
        
        it(@"missing username", ^{
            verifyValidationErrorMessageIsShown(@"Username is required",
                                                RTResetPasswordErrorMissingUsername,
                                                RTResetPasswordViewFieldUsername);
        });
        
        it(@"missing password", ^{
            verifyValidationErrorMessageIsShown(@"Password is required",
                                                RTResetPasswordErrorMissingPassword,
                                                RTResetPasswordViewFieldPassword);
        });
        
        it(@"invalid password", ^{
            verifyValidationErrorMessageIsShown(@"Password must be at least 6 characters",
                                                RTResetPasswordErrorInvalidPassword,
                                                RTResetPasswordViewFieldPassword);
        });
        
        it(@"missing confirmation password", ^{
            verifyValidationErrorMessageIsShown(@"Confirmation password is required",
                                                RTResetPasswordErrorMissingConfirmationPassword,
                                                RTResetPasswordViewFieldConfirmationPassword);
        });
        
        it(@"password and confirmation password do not match", ^{
            verifyErrorMessageIsShown(@"Password and confirmation password must match",
                                      RTResetPasswordErrorConfirmationPasswordDoesNotMatch);
        });
        
        it(@"missing client name", ^{
            verifyValidationErrorMessageIsShown(@"Client name is required",
                                                RTResetPasswordErrorMissingClientName,
                                                RTResetPasswordViewFieldClientName);
        });
        
        it(@"email failure", ^{
            verifyErrorMessageIsShown(@"We were not able to send the reset password email at this time. Try again shortly.",
                                      RTResetPasswordErrorEmailFailure);
        });

        it(@"unknown, unauthenticated or unauthorized client", ^{
            NSString *expected = @"We could not recognize this device. Please register a new one.";

            verifyErrorMessageIsShown(expected, RTResetPasswordErrorUnknownClient);
            verifyErrorMessageIsShown(expected, RTResetPasswordErrorInvalidClientCredentials);
            verifyErrorMessageIsShown(expected, RTResetPasswordErrorForbiddenClient);
        });
        
        it(@"registered new client but failed to save credentials", ^{
            verifyErrorMessageIsShown(@"We reset your password, but encountered a problem while registering this device. Please try again later.", RTResetPasswordErrorFailedToSaveClientCredentials);
        });
    });
});

SpecEnd