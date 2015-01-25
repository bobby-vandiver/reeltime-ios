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
            
            [verify(view) showErrorMessages:@[message]];
            [verify(wireframe) presentDeviceRegistrationInterface];
        });
        
        it(@"should inform user of failure to auto login and present login interface", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:LoginUnableToSetCurrentlyLoggedInUser];
            [presenter registrationWithAutoLoginFailedWithError:error];
            
            NSString *message = @"Account was registered but we were unable to log you in automatically."
                                @"Please login.";
            
            [verify(view) showErrorMessages:@[message]];
            [verify(wireframe) presentLoginInterface];
        });
    });
});

SpecEnd