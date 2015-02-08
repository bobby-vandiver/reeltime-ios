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
        it(@"should pass request on to the interactor", ^{
            [presenter requestedNewsfeedPage:23];
            [verify(interactor) newsfeedPage:23];
        });
    });
    
    describe(@"show newsfeed page activities", ^{
        __block RTNewsfeed *newsfeed;
        
        beforeEach(^{
            newsfeed = [[RTNewsfeed alloc] init];
        });
        
        it(@"no activities to show", ^{
            newsfeed.activities = @[];
            [presenter retrievedNewsfeed:newsfeed];
            [verifyCount(view, never()) showActivity:anything()];
        });
        
        it(@"one activity to show", ^{
            RTActivity *activity = [[RTActivity alloc] init];
            newsfeed.activities = @[activity];
            
            [presenter retrievedNewsfeed:newsfeed];
            [verify(view) showActivity:activity];
        });
        
        it(@"multiple activities to show", ^{
            RTActivity *activity1 = [[RTActivity alloc] init];
            RTActivity *activity2 = [[RTActivity alloc] init];
            RTActivity *activity3 = [[RTActivity alloc] init];
            
            newsfeed.activities = @[activity1, activity2, activity3];
            [presenter retrievedNewsfeed:newsfeed];
            
            [verify(view) showActivity:activity1];
            [verify(view) showActivity:activity2];
            [verify(view) showActivity:activity3];
        });
    });
});

SpecEnd
