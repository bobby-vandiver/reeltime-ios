#import "RTTestCommon.h"

#import "RTResetPasswordPresenter.h"

#import "RTResetPasswordView.h"
#import "RTResetPasswordInteractor.h"
#import "RTResetPasswordWireframe.h"

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
});

SpecEnd