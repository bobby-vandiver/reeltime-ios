#import "RTTestCommon.h"

#import "RTLogoutPresenter.h"

#import "RTLogoutView.h"
#import "RTLogoutInteractor.h"
#import "RTLogoutWireframe.h"

SpecBegin(RTLogoutPresenter)

describe(@"logout presenter", ^{
    
    __block RTLogoutPresenter *presenter;
    __block id<RTLogoutView> view;
    
    __block RTLogoutInteractor *interactor;
    __block RTLogoutWireframe *wireframe;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTLogoutView));
        interactor = mock([RTLogoutInteractor class]);
        wireframe = mock([RTLogoutWireframe class]);
        
        presenter = [[RTLogoutPresenter alloc] initWithView:view
                                                 interactor:interactor
                                                  wireframe:wireframe];
    });
    
    describe(@"requested logout", ^{
        it(@"should invoke interactor", ^{
            [presenter requestedLogout];
            [verify(interactor) logout];
        });
    });
    
    describe(@"logout succeeded", ^{
        it(@"should present login interface", ^{
            [presenter logoutSucceeded];
            [verify(wireframe) presentLoginInterface];
        });
    });
    
    describe(@"logout failed", ^{
        it(@"should present error message", ^{
            [presenter logoutFailed];
            [verify(view) showErrorMessage:@"Logout failed!"];
        });
    });
});

SpecEnd