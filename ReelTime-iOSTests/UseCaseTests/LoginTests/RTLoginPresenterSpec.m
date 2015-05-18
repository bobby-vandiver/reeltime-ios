#import "RTTestCommon.h"

#import "RTLoginPresenter.h"
#import "RTLoginView.h"
#import "RTLoginInteractor.h"
#import "RTLoginWireframe.h"

#import "RTErrorFactory.h"

SpecBegin(RTLoginPresenter)

describe(@"login presenter", ^{
    
    __block RTLoginPresenter *presenter;
    
    __block id<RTLoginView> view;
    __block RTLoginInteractor *interactor;
    __block RTLoginWireframe *wireframe;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTLoginView));
        interactor = mock([RTLoginInteractor class]);
        wireframe = mock([RTLoginWireframe class]);
        
        presenter = [[RTLoginPresenter alloc] initWithView:view
                                                interactor:interactor
                                                 wireframe:wireframe];
    });
    
    describe(@"when login is requested", ^{
        it(@"should pass credentials to interactor", ^{
            [presenter requestedLoginWithUsername:username password:password];
            [verify(interactor) loginWithUsername:username password:password];
        });
    });
    
    describe(@"login failure", ^{
        it(@"should indicate an unknown error occurred if error domain is incorrect", ^{
            NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain
                                                 code:0
                                             userInfo:nil];
            [presenter loginFailedWithErrors:@[error]];
            [verify(view) showErrorMessage:@"An unknown error occurred"];
        });
        
        it(@"should report missing username", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:RTLoginErrorMissingUsername];
            [presenter loginFailedWithErrors:@[error]];

            [verify(view) showValidationErrorMessage:@"Username is required" forField:RTLoginViewFieldUsername];
        });

        it(@"should report missing password", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:RTLoginErrorMissingPassword];
            [presenter loginFailedWithErrors:@[error]];

            [verify(view) showValidationErrorMessage:@"Password is required" forField:RTLoginViewFieldPassword];
        });
        
        it(@"should report missing username and missing password", ^{
            NSError *missingUsername = [RTErrorFactory loginErrorWithCode:RTLoginErrorMissingUsername];
            NSError *missingPassword = [RTErrorFactory loginErrorWithCode:RTLoginErrorMissingPassword];
            
            [presenter loginFailedWithErrors:@[missingUsername, missingPassword]];
            
            [verify(view) showValidationErrorMessage:@"Username is required" forField:RTLoginViewFieldUsername];
            [verify(view) showValidationErrorMessage:@"Password is required" forField:RTLoginViewFieldPassword];
        });

        it(@"should not indicate source of failure for invalid credentials", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:RTLoginErrorInvalidCredentials];
            [presenter loginFailedWithErrors:@[error]];
            
            [verify(view) showErrorMessage:@"Invalid username or password"];
        });
        
        it(@"should indicate an unknown error occurred for any other login errors", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:RTLoginErrorUnableToSetCurrentlyLoggedInUser];
            [presenter loginFailedWithErrors:@[error]];
            
            [verify(view) showErrorMessage:@"An unknown error occurred"];
        });
    });
    
    describe(@"routing to other modules", ^{
        it(@"should present device registration interface when requested", ^{
            [presenter requestedDeviceRegistration];
            [verify(wireframe) presentDeviceRegistrationInterface];
        });
        
        it(@"should present account registration interface when requested", ^{
            [presenter requestedAccountRegistration];
            [verify(wireframe) presentAccountRegistrationInterface];
        });
        
        it(@"should present reset password interface when requested", ^{
            [presenter requestedResetPassword];
            [verify(wireframe) presentResetPasswordInterface];
        });
        
        it(@"should present post login interface when login succeeds", ^{
            [presenter loginSucceeded];
            [verify(wireframe) presentPostLoginInterface];
        });
        
        it(@"should present device registration interface for an unknown client", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:RTLoginErrorUnknownClient];
            
            [presenter loginFailedWithErrors:@[error]];
            [verify(wireframe) presentDeviceRegistrationInterface];
        });
    });
});

SpecEnd
