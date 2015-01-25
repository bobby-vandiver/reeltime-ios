#import "RTTestCommon.h"

#import "RTAccountRegistrationPresenter.h"
#import "RTAccountRegistrationView.h"
#import "RTAccountRegistrationInteractor.h"
#import "RTAccountRegistrationWireframe.h"

#import "RTAccountRegistration.h"
#import "RTAccountRegistrationErrors.h"

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
});

SpecEnd