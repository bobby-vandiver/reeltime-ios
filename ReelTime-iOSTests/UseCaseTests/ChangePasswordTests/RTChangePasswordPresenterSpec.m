#import "RTTestCommon.h"

#import "RTChangePasswordPresenter.h"
#import "RTChangePasswordView.h"
#import "RTChangePasswordInteractor.h"
#import "RTChangePasswordWireframe.h"

SpecBegin(RTChangePasswordPresenter)

describe(@"change password presenter", ^{
    
    __block RTChangePasswordPresenter *presenter;
    __block id<RTChangePasswordView> view;
    
    __block RTChangePasswordInteractor *interactor;
    __block RTChangePasswordWireframe *wireframe;
    
    beforeEach(^{
        wireframe = mock([RTChangePasswordWireframe class]);
        interactor = mock([RTChangePasswordInteractor class]);
        
        view = mockProtocol(@protocol(RTChangePasswordView));
        presenter = [[RTChangePasswordPresenter alloc] initWithView:view interactor:interactor wireframe:wireframe];
    });
    
    describe(@"requesting password change", ^{
        it(@"should pass on to interactor", ^{
            [presenter requestedPasswordChangeWithPassword:password confirmationPassword:confirmationPassword];
            [verify(interactor) changePassword:password confirmationPassword:confirmationPassword];
        });
    });
    
    describe(@"password change was successful", ^{
        it(@"should present a success message", ^{
            [presenter changePasswordSucceeded];
            [verify(view) showMessage:@"Password change succeeded"];
        });
    });
});

SpecEnd
