#import "RTTestCommon.h"

#import "RTChangeDisplayNamePresenter.h"
#import "RTChangeDisplayNameView.h"
#import "RTChangeDisplayNameInteractor.h"

#import "RTErrorFactory.h"

SpecBegin(RTChangeDisplayNamePresenter)

describe(@"change display name presenter", ^{
    
    __block RTChangeDisplayNamePresenter *presenter;
    
    __block id<RTChangeDisplayNameView> view;
    __block RTChangeDisplayNameInteractor *interactor;
    
    beforeEach(^{
        interactor = mock([RTChangeDisplayNameInteractor class]);
        view = mockProtocol(@protocol(RTChangeDisplayNameView));
        
        presenter = [[RTChangeDisplayNamePresenter alloc] initWithView:view interactor:interactor];
    });
    
    describe(@"requesting display name change", ^{
        it(@"should pass on to interactor", ^{
            [presenter requestedDisplayNameChangeWithDisplayName:displayName];
            [verify(interactor) changeDisplayName:displayName];
        });
    });
    
    describe(@"display name change was successful", ^{
        it(@"should present a success message", ^{
            [presenter changeDisplayNameSucceeded];
            [verify(view) showMessage:@"Display name change succeeded"];
        });
    });
});

SpecEnd