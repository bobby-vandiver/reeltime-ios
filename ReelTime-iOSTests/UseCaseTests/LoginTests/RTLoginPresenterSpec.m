#import "RTTestCommon.h"

#import "RTLoginPresenter.h"
#import "RTLoginView.h"
#import "RTLoginInteractor.h"
#import "RTLoginWireframe.h"

#import "RTLoginPresentationModel.h"
#import "RTConditionalMessage.h"

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
        __block RTLoginPresentationModel *presentationModel;
        
        beforeEach(^{
            presentationModel = nil;
        });
        
        void (^presentLoginErrors)(NSArray *) = ^(NSArray *errors) {
            MKTArgumentCaptor *presentationModelCaptor = [[MKTArgumentCaptor alloc] init];
            
            [presenter loginFailedWithErrors:errors];
            [verify(view) updateWithPresentationModel:[presentationModelCaptor capture]];
            
            presentationModel = [presentationModelCaptor value];
        };
        
        it(@"should indicate an unknown error occurred if error domain is incorrect", ^{
            NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain
                                                 code:0
                                             userInfo:nil];
            presentLoginErrors(@[error]);
            
            expect(presentationModel.unknownErrorOccurred.condition).to.beTruthy();
            expect(presentationModel.unknownErrorOccurred.message).to.equal(@"An unknown error occurred");
        });
        
        it(@"should report missing username", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:RTLoginErrorMissingUsername];
            presentLoginErrors(@[error]);
            
            expect(presentationModel.validUsername.condition).to.beFalsy();
            expect(presentationModel.validUsername.message).to.equal(@"Username is required");
        });

        it(@"should report missing password", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:RTLoginErrorMissingPassword];
            presentLoginErrors(@[error]);

            expect(presentationModel.validPassword.condition).to.beFalsy();
            expect(presentationModel.validPassword.message).to.equal(@"Password is required");
        });
        
        it(@"should report missing username and missing password", ^{
            NSError *missingUsername = [RTErrorFactory loginErrorWithCode:RTLoginErrorMissingUsername];
            NSError *missingPassword = [RTErrorFactory loginErrorWithCode:RTLoginErrorMissingPassword];
            
            presentLoginErrors(@[missingUsername, missingPassword]);
            
            expect(presentationModel.validUsername.condition).to.beFalsy();
            expect(presentationModel.validUsername.message).to.equal(@"Username is required");

            expect(presentationModel.validPassword.condition).to.beFalsy();
            expect(presentationModel.validPassword.message).to.equal(@"Password is required");
            
            expect(presentationModel.validCredentials.condition).to.beTruthy();
            expect(presentationModel.unknownErrorOccurred.condition).to.beFalsy();
        });

        it(@"should not indicate source of failure for invalid credentials", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:RTLoginErrorInvalidCredentials];
            presentLoginErrors(@[error]);
            
            expect(presentationModel.validCredentials.condition).to.beFalsy();
            expect(presentationModel.validCredentials.message).to.equal(@"Invalid username or password");
            
            expect(presentationModel.validUsername.condition).to.beTruthy();
            expect(presentationModel.validPassword.condition).to.beTruthy();
        });
        
        it(@"should indicate an unknown error occurred for any other login errors", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:RTLoginErrorUnableToSetCurrentlyLoggedInUser];
            presentLoginErrors(@[error]);

            expect(presentationModel.unknownErrorOccurred.condition).to.beTruthy();
            expect(presentationModel.unknownErrorOccurred.message).to.equal(@"An unknown error occurred");
        });
    });
    
    describe(@"routing to other modules", ^{
        it(@"should present account registration interface when requested", ^{
            [presenter requestedAccountRegistration];
            [verify(wireframe) presentAccountRegistrationInterface];
        });
        
        it(@"should present post login interface when login succeeds", ^{
            [presenter loginSucceeded];
            [verify(wireframe) presentPostLoginInterface];
        });
        
        it(@"should present device registration interface for an unknown client", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:RTLoginErrorUnknownClient];
            
            [presenter loginFailedWithErrors:@[error]];
            [verify(wireframe) presentDeviceRegistrationInterface];
            
            [verifyCount(view, never()) updateWithPresentationModel:anything()];
        });
    });
});

SpecEnd
