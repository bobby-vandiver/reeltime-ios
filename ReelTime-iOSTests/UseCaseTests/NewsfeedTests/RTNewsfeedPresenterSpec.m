#import "RTTestCommon.h"

#import "RTNewsfeedPresenter.h"

#import "RTNewsfeedView.h"
#import "RTNewsfeedInteractor.h"
#import "RTNewsfeedWireframe.h"

#import "RTNewsfeed.h"
#import "RTActivity.h"

SpecBegin(RTNewsfeedPresenter)

describe(@"newsfeed presenter", ^{

    __block RTNewsfeedPresenter *presenter;

    __block id<RTNewsfeedView> view;
    __block RTNewsfeedInteractor *interactor;
    __block RTNewsfeedWireframe *wireframe;

    beforeEach(^{
        view = mockProtocol(@protocol(RTNewsfeedView));
        interactor = mock([RTNewsfeedInteractor class]);
        wireframe = mock([RTNewsfeedWireframe class]);
        
        presenter = [[RTNewsfeedPresenter alloc] initWithView:view
                                                   interactor:interactor
                                                    wireframe:wireframe];
    });
    
    describe(@"newsfeed page requested", ^{
        it(@"should always get the next requested page", ^{
            [presenter requestedNextNewsfeedPage];
            [verify(interactor) newsfeedPage:1];
            
            [presenter requestedNextNewsfeedPage];
            [verify(interactor) newsfeedPage:2];
            
            [presenter requestedNextNewsfeedPage];
            [verify(interactor) newsfeedPage:3];
        });
    });
    
    describe(@"newsfeed reset", ^{
        it(@"should reset page counter so the first page is retrieved next", ^{
            [presenter requestedNextNewsfeedPage];
            [verify(interactor) newsfeedPage:1];
            
            [presenter requestedNextNewsfeedPage];
            [verify(interactor) newsfeedPage:2];

            [presenter requestedNewsfeedReset];
            [verify(interactor) reset];
            
            [presenter requestedNextNewsfeedPage];
            [verify(interactor) newsfeedPage:1];
        });
        
        it(@"should notify view that currently displayed messages should be removed", ^{
            [presenter requestedNewsfeedReset];
            [verify(view) clearMessages];
        });
    });
    
    // TODO: Add tests for showing activities
    describe(@"show newsfeed page activities", ^{
        __block RTNewsfeed *newsfeed;
        
        beforeEach(^{
            newsfeed = [[RTNewsfeed alloc] init];
        });
        
        it(@"no activities to show", ^{
            newsfeed.activities = @[];
            [presenter retrievedNewsfeed:newsfeed];
            [verifyCount(view, never()) showMessage:anything() forActivityType:0];
        });
    });
});

SpecEnd
