#import "RTTestCommon.h"

#import "RTAccountRegistrationPresenter.h"
#import "RTAccountRegistrationView.h"
#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationWireframe.h"

#import "RTAccountRegistration.h"
#import "RTAccountRegistrationError.h"

#import "RTErrorFactory.h"

SpecBegin(RTAccountRegistrationPresenter)

describe(@"account registration presenter", ^{
    
    __block RTAccountRegistrationPresenter *presenter;
    
    __block id<RTAccountRegistrationView> view;
    
    __block RTAccountRegistrationInteractor *interactor;
    __block RTAccountRegistrationWireframe *wireframe;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTAccountRegistrationView));

        interactor = mock([RTAccountRegistrationInteractor class]);
        wireframe = mock([RTAccountRegistrationWireframe class]);
        
        presenter = [[RTAccountRegistrationPresenter alloc] initWithView:view
                                                              interactor:interactor
                                                               wireframe:wireframe];
    });
    
    describe(@"requesting registration", ^{
        it(@"should pass registration to interactor", ^{
            NSString *confirmationPassword = @"confirmation";
            expect(confirmationPassword).toNot.equal(password);
            
            [presenter requestedAccountRegistrationWithUsername:username
                                                       password:password
                                           confirmationPassword:confirmationPassword
                                                          email:email
                                                    displayName:displayName
                                                     clientName:clientName];
            
            MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
            [verify(interactor) registerAccount:[captor capture]];
            
            RTAccountRegistration *registration = [captor value];
            expect(registration.username).to.equal(username);
            expect(registration.password).to.equal(password);
            expect(registration.confirmationPassword).to.equal(confirmationPassword);
            expect(registration.email).to.equal(email);
            expect(registration.displayName).to.equal(displayName);
            expect(registration.clientName).to.equal(clientName);
        });
    });
    
    describe(@"successful registration", ^{
        
        it(@"should present the post auto login interface when registration and auto login succeed", ^{
            [presenter loginSucceeded];
            [verify(wireframe) presentPostAutoLoginInterface];
        });
        
        it(@"should inform user of failure to associate device then present device registration inteface", ^{
            NSError *error = [RTErrorFactory accountRegistrationErrorWithCode:RTAccountRegistrationErrorUnableToAssociateClientWithDevice];
            [presenter registrationWithAutoLoginFailedWithError:error];
            
            NSString *message = @"Account was registered but we were unable to associate your device with your account."
                                @"Please register your device separately.";
            
            [verify(view) showErrorMessage:message];
            [verify(wireframe) presentDeviceRegistrationInterface];
        });
        
        it(@"should inform user of failure to auto login and present login interface", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:RTLoginErrorUnableToSetCurrentlyLoggedInUser];
            [presenter loginFailedWithErrors:@[error]];
            
            NSString *message = @"Account was registered but we were unable to log you in automatically."
                                @"Please login.";
            
            [verify(view) showErrorMessage:message];
            [verify(wireframe) presentLoginInterface];
        });
    });
    
    describe(@"registration failure message", ^{

        #define verifyValidationErrorMessageIsShown(msg, code, field) do {              \
            NSError *error = [RTErrorFactory accountRegistrationErrorWithCode:code];    \
                                                                                        \
            [presenter registrationFailedWithErrors:@[error]];                          \
            [verify(view) showValidationErrorMessage:msg forField:field];               \
        } while(0)
        
        #define verifyErrorMessageIsShown(msg, code) do {                               \
            NSError *error = [RTErrorFactory accountRegistrationErrorWithCode:code];    \
                                                                                        \
            [presenter registrationFailedWithErrors:@[error]];                          \
            [verify(view) showErrorMessage:msg];                                        \
        } while(0)
        
        it(@"missing username", ^{
            verifyValidationErrorMessageIsShown(@"Username is required",
                                                RTAccountRegistrationErrorMissingUsername,
                                                RTAccountRegistrationViewFieldUsername);
        });
        
        it(@"invalid username", ^{
            verifyValidationErrorMessageIsShown(@"Username must be 2-15 alphanumeric characters",
                                                RTAccountRegistrationErrorInvalidUsername,
                                                RTAccountRegistrationViewFieldUsername);
        });
        
        it(@"username is not available", ^{
            verifyValidationErrorMessageIsShown(@"Username is unavailable",
                                                RTAccountRegistrationErrorUsernameIsUnavailable,
                                                RTAccountRegistrationViewFieldUsername);
        });
        
        it(@"missing password", ^{
            verifyValidationErrorMessageIsShown(@"Password is required",
                                                RTAccountRegistrationErrorMissingPassword,
                                                RTAccountRegistrationViewFieldPassword);
        });
        
        it(@"invalid password", ^{
            verifyValidationErrorMessageIsShown(@"Password must be at least 6 characters",
                                                RTAccountRegistrationErrorInvalidPassword,
                                                RTAccountRegistrationViewFieldPassword);
        });
        
        it(@"missing confirmation password", ^{
            verifyValidationErrorMessageIsShown(@"Confirmation password is required",
                                                RTAccountRegistrationErrorMissingConfirmationPassword,
                                                RTAccountRegistrationViewFieldConfirmationPassword);
        });
        
        it(@"password and confirmation password do not match", ^{
            verifyErrorMessageIsShown(@"Password and confirmation password must match",
                                      RTAccountRegistrationErrorConfirmationPasswordDoesNotMatch);
        });
        
        it(@"missing email", ^{
            verifyValidationErrorMessageIsShown(@"Email is required",
                                                RTAccountRegistrationErrorMissingEmail,
                                                RTAccountRegistrationViewFieldEmail);
        });
        
        it(@"invalid email", ^{
            verifyValidationErrorMessageIsShown(@"Email is not a valid email address",
                                                RTAccountRegistrationErrorInvalidEmail,
                                                RTAccountRegistrationViewFieldEmail);
        });
        
        it(@"missing display name", ^{
            verifyValidationErrorMessageIsShown(@"Display name is required",
                                                RTAccountRegistrationErrorMissingDisplayName,
                                                RTAccountRegistrationViewFieldDisplayName);
        });
        
        it(@"invalid display name", ^{
            verifyValidationErrorMessageIsShown(@"Display name must be 2-20 alphanumeric or space characters",
                                                RTAccountRegistrationErrorInvalidDisplayName,
                                                RTAccountRegistrationViewFieldDisplayName);
        });
        
        it(@"missing client name", ^{
            verifyValidationErrorMessageIsShown(@"Client name is required",
                                                RTAccountRegistrationErrorMissingClientName,
                                                RTAccountRegistrationViewFieldClientName);
        });
        
        it(@"registration service is unavailable", ^{
            verifyErrorMessageIsShown(@"Unable to register at this time. Please try again.",
                                      RTAccountRegistrationErrorRegistrationServiceUnavailable);
        });
    });
});

SpecEnd