#import "RTTestCommon.h"

#import "RTAccountRegistrationPresenter.h"
#import "RTAccountRegistrationView.h"
#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationWireframe.h"

#import "RTAccountRegistration.h"
#import "RTAccountRegistrationErrors.h"

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
            [presenter registrationWithAutoLoginSucceeded];
            [verify(wireframe) presentPostAutoLoginInterface];
        });
        
        it(@"should inform user of failure to associate device then present device registration inteface", ^{
            NSError *error = [RTErrorFactory accountRegistrationErrorWithCode:AccountRegistrationUnableToAssociateClientWithDevice];
            [presenter registrationWithAutoLoginFailedWithError:error];
            
            NSString *message = @"Account was registered but we were unable to associate your device with your account."
                                @"Please register your device separately.";
            
            [verify(view) showErrorMessage:message];
            [verify(wireframe) presentDeviceRegistrationInterface];
        });
        
        it(@"should inform user of failure to auto login and present login interface", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:LoginUnableToSetCurrentlyLoggedInUser];
            [presenter registrationWithAutoLoginFailedWithError:error];
            
            NSString *message = @"Account was registered but we were unable to log you in automatically."
                                @"Please login.";
            
            [verify(view) showErrorMessage:message];
            [verify(wireframe) presentLoginInterface];
        });
    });
    
    describe(@"registration failure message", ^{
        
        #define verifyErrorMessageIsShown(msg, code) do {                               \
            NSError *error = [RTErrorFactory accountRegistrationErrorWithCode:code];    \
                                                                                        \
            [presenter registrationFailedWithErrors:@[error]];                          \
            [verify(view) showErrorMessage:@msg];                                       \
        } while(0)
        
        it(@"missing username", ^{
            verifyErrorMessageIsShown("Username is required",
                                      AccountRegistrationMissingUsername);
        });
        
        it(@"invalid username", ^{
            verifyErrorMessageIsShown("Username must be 2-15 alphanumeric characters",
                                      AccountRegistrationInvalidUsername);
        });
        
        it(@"username is not available", ^{
            verifyErrorMessageIsShown("Username is unavailable",
                                      AccountRegistrationUsernameIsUnavailable);
        });
        
        it(@"missing password", ^{
            verifyErrorMessageIsShown("Password is required",
                                      AccountRegistrationMissingPassword);
        });
        
        it(@"invalid password", ^{
            verifyErrorMessageIsShown("Password must be at least 6 characters",
                                      AccountRegistrationInvalidPassword);
        });
        
        it(@"missing confirmation password", ^{
            verifyErrorMessageIsShown("Confirmation password is required",
                                      AccountRegistrationMissingConfirmationPassword);
        });
        
        it(@"password and confirmation password do not match", ^{
            verifyErrorMessageIsShown("Password and confirmation password must match",
                                      AccountRegistrationConfirmationPasswordDoesNotMatch);
        });
        
        it(@"missing email", ^{
            verifyErrorMessageIsShown("Email is required",
                                      AccountRegistrationMissingEmail);
        });
        
        it(@"invalid email", ^{
            verifyErrorMessageIsShown("Email is not a valid email address",
                                      AccountRegistrationInvalidEmail);
        });
        
        it(@"missing display name", ^{
            verifyErrorMessageIsShown("Display name is required",
                                      AccountRegistrationMissingDisplayName);
        });
        
        it(@"invalid display name", ^{
            verifyErrorMessageIsShown("Display name must be 2-20 alphanumeric or space characters",
                                      AccountRegistrationInvalidDisplayName);
        });
        
        it(@"missing client name", ^{
            verifyErrorMessageIsShown("Client name is required",
                                      AccountRegistrationMissingClientName);
        });
        
        it(@"registration service is unavailable", ^{
            verifyErrorMessageIsShown("Unable to register at this time. Please try again.",
                                      AccountRegistrationRegistrationServiceUnavailable);
        });
    });
});

SpecEnd