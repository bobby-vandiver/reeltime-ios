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
    
    describe(@"login failure message", ^{
        it(@"should be generic if error domain is incorrect", ^{
            NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain
                                                 code:0
                                             userInfo:nil];

            [presenter loginFailedWithErrors:@[error]];
            [verify(view) showErrorMessage:@"An unknown error occurred"];
        });
        
        it(@"should report missing username", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:LoginMissingUsername];
            
            [presenter loginFailedWithErrors:@[error]];
            [verify(view) showErrorMessage:@"Username is required"];
        });
        
        it(@"should report missing password", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:LoginMissingPassword];
            
            [presenter loginFailedWithErrors:@[error]];
            [verify(view) showErrorMessage:@"Password is required"];
        });
        
        it(@"should not indicate source of failure for invalid credentials", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:LoginInvalidCredentials];
            
            [presenter loginFailedWithErrors:@[error]];
            [verify(view) showErrorMessage:@"Invalid username or password"];
        });
    });
    
    describe(@"routing to other modules", ^{
        it(@"should present post login interface when login succeeds", ^{
            [presenter loginSucceeded];
            [verify(wireframe) presentPostLoginInterface];
        });
        
        it(@"should present device registration interface for an unknown client", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:LoginUnknownClient];
            
            [presenter loginFailedWithErrors:@[error]];
            [verify(wireframe) presentDeviceRegistrationInterface];
        });
    });
});

SpecEnd
