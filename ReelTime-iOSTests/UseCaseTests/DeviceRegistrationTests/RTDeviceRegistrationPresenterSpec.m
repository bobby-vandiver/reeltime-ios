#import "RTTestCommon.h"

#import "RTDeviceRegistrationPresenter.h"
#import "RTDeviceRegistrationView.h"
#import "RTDeviceRegistrationInteractor.h"
#import "RTDeviceRegistrationWireframe.h"

#import "RTDeviceRegistrationError.h"
#import "RTErrorFactory.h"

SpecBegin(RTDeviceRegistrationPresenter)

describe(@"device registration presenter", ^{
    
    __block RTDeviceRegistrationPresenter *presenter;
    __block id<RTDeviceRegistrationView> view;

    __block RTDeviceRegistrationInteractor *interactor;
    __block RTDeviceRegistrationWireframe *wireframe;
    
    beforeEach(^{
        wireframe = mock([RTDeviceRegistrationWireframe class]);
        interactor = mock([RTDeviceRegistrationInteractor class]);
        
        view = mockProtocol(@protocol(RTDeviceRegistrationView));
        presenter = [[RTDeviceRegistrationPresenter alloc] initWithView:view
                                                             interactor:interactor
                                                              wireframe:wireframe];
    });
    
    describe(@"requesting device registration", ^{
        it(@"should instruct interactor to perform the registration", ^{
            [presenter requestedDeviceRegistrationWithClientName:clientName username:username password:password];
            [verify(interactor) registerDeviceWithClientName:clientName username:username password:password];
        });
    });

    describe(@"registration failure", ^{
        it(@"should not inform view if error domain is incorrect", ^{
            NSError *error = [NSError errorWithDomain:NSInvalidArgumentException
                                                 code:0
                                             userInfo:nil];

            [presenter deviceRegistrationFailedWithErrors:@[error]];

            [verifyCount(view, never()) showErrorMessage:anything()];
            [[verifyCount(view, never()) withMatcher:anything() forArgument:1] showValidationErrorMessage:anything() forField:0];
        });
        
        it(@"should report missing username", ^{
            NSError *error = [RTErrorFactory deviceRegistrationErrorWithCode:RTDeviceRegistrationErrorMissingUsername];
            [presenter deviceRegistrationFailedWithErrors:@[error]];
            
            [verify(view) showValidationErrorMessage:@"Username is required" forField:RTDeviceRegistrationViewFieldUsername];
        });
        
        it(@"should report missing password", ^{
            NSError *error = [RTErrorFactory deviceRegistrationErrorWithCode:RTDeviceRegistrationErrorMissingPassword];
            [presenter deviceRegistrationFailedWithErrors:@[error]];

            [verify(view) showValidationErrorMessage:@"Password is required" forField:RTDeviceRegistrationViewFieldPassword];
        });
        
        it(@"should report missing client name", ^{
            NSError *error = [RTErrorFactory deviceRegistrationErrorWithCode:RTDeviceRegistrationErrorMissingClientName];
            [presenter deviceRegistrationFailedWithErrors:@[error]];
            
            [verify(view) showValidationErrorMessage:@"Client name is required" forField:RTDeviceRegistrationViewFieldClientName];
        });
        
        it(@"should report all missing fields", ^{
            NSError *missingUsername = [RTErrorFactory deviceRegistrationErrorWithCode:RTDeviceRegistrationErrorMissingUsername];
            NSError *missingPassword = [RTErrorFactory deviceRegistrationErrorWithCode:RTDeviceRegistrationErrorMissingPassword];
            NSError *missingClientName = [RTErrorFactory deviceRegistrationErrorWithCode:RTDeviceRegistrationErrorMissingClientName];
            
            [presenter deviceRegistrationFailedWithErrors:@[missingUsername, missingPassword, missingClientName]];
            
            [verify(view) showValidationErrorMessage:@"Username is required" forField:RTDeviceRegistrationViewFieldUsername];
            [verify(view) showValidationErrorMessage:@"Password is required" forField:RTDeviceRegistrationViewFieldPassword];
            [verify(view) showValidationErrorMessage:@"Client name is required" forField:RTDeviceRegistrationViewFieldClientName];
        });
        
        it(@"should report invalid credentials", ^{
            NSError *error = [RTErrorFactory deviceRegistrationErrorWithCode:RTDeviceRegistrationErrorInvalidCredentials];
            [presenter deviceRegistrationFailedWithErrors:@[error]];
            
            [verify(view) showErrorMessage:@"Invalid username or password"];
        });
    });
    
    describe(@"routing to other modules", ^{
        it(@"should present login interface when registration is successful", ^{
            [presenter deviceRegistrationSucceeded];
            [verify(wireframe) presentLoginInterface];
        });
    });
});

SpecEnd