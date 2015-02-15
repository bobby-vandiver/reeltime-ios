#import "RTTestCommon.h"

#import "RTNewsfeedPresenter.h"

#import "RTNewsfeedView.h"
#import "RTNewsfeedInteractor.h"
#import "RTNewsfeedWireframe.h"
#import "RTNewsfeedMessageSource.h"

#import "RTNewsfeed.h"
#import "RTActivity.h"

#import "RTUser.h"
#import "RTReel.h"
#import "RTVideo.h"

#import "RTStringWithEmbeddedLinks.h"
#import "RTEmbeddedURL.h"

SpecBegin(RTNewsfeedPresenter)

describe(@"newsfeed presenter", ^{

    __block RTNewsfeedPresenter *presenter;

    __block id<RTNewsfeedView> view;
    __block RTNewsfeedInteractor *interactor;
    __block RTNewsfeedWireframe *wireframe;
    __block RTNewsfeedMessageSource *messageSource;

    beforeEach(^{
        view = mockProtocol(@protocol(RTNewsfeedView));
        interactor = mock([RTNewsfeedInteractor class]);
        wireframe = mock([RTNewsfeedWireframe class]);
        messageSource = mock([RTNewsfeedMessageSource class]);
        
        presenter = [[RTNewsfeedPresenter alloc] initWithView:view
                                                   interactor:interactor
                                                    wireframe:wireframe
                                                messageSource:messageSource];
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
    
    describe(@"show newsfeed page activities", ^{
        __block RTNewsfeed *newsfeed;
        __block RTUser *user;
        __block RTReel *reel;
        __block RTVideo *video;
        
        beforeEach(^{
            newsfeed = [[RTNewsfeed alloc] init];
            
            user = [[RTUser alloc] initWithUsername:username displayName:displayName
                                  numberOfFollowers:@(1) numberOfFollowees:@(2)];

            reel = [[RTReel alloc] initWithReelId:@(1) name:@"reel" audienceSize:@(2) numberOfVideos:@(3)];

            video = [[RTVideo alloc] initWithVideoId:@(1) title:@"title"];
        });
        
        it(@"no activities to show", ^{
            newsfeed.activities = @[];
            [presenter retrievedNewsfeed:newsfeed];
            [verifyCount(view, never()) showMessage:anything() forActivityType:0];
        });
       
        it(@"show create reel activity", ^{
            RTActivity *activity = [RTActivity createReelActivityWithUser:user reel:reel];
            newsfeed.activities = @[activity];
            
            RTStringWithEmbeddedLinks *message = [[RTStringWithEmbeddedLinks alloc] init];
            [given([messageSource messageForActivity:activity]) willReturn:message];
            
            [presenter retrievedNewsfeed:newsfeed];
            [verify(view) showMessage:message forActivityType:RTActivityTypeCreateReel];
        });
        
        it(@"show join reel activity", ^{
            RTActivity *activity = [RTActivity joinReelActivityWithUser:user reel:reel];
            newsfeed.activities= @[activity];

            RTStringWithEmbeddedLinks *message = [[RTStringWithEmbeddedLinks alloc] init];
            [given([messageSource messageForActivity:activity]) willReturn:message];

            [presenter retrievedNewsfeed:newsfeed];
            [verify(view) showMessage:message forActivityType:RTActivityTypeJoinReelAudience];
        });
        
        it(@"show add video to reel activity", ^{
            RTActivity *activity = [RTActivity addVideoToReelActivityWithUser:user reel:reel video:video];
            newsfeed.activities = @[activity];

            RTStringWithEmbeddedLinks *message = [[RTStringWithEmbeddedLinks alloc] init];
            [given([messageSource messageForActivity:activity]) willReturn:message];
            
            [presenter retrievedNewsfeed:newsfeed];
            [verify(view) showMessage:message forActivityType:RTActivityTypeAddVideoToReel];
        });
        
        it(@"show multiple activities", ^{
            RTActivity *createReelActivity = [RTActivity createReelActivityWithUser:user reel:reel];
            RTActivity *addVideoToReelActivity = [RTActivity addVideoToReelActivityWithUser:user reel:reel video:video];
            
            newsfeed.activities = @[createReelActivity, addVideoToReelActivity];
            
            RTStringWithEmbeddedLinks *createReelMessage = [[RTStringWithEmbeddedLinks alloc] init];
            [given([messageSource messageForActivity:createReelActivity]) willReturn:createReelMessage];
            
            RTStringWithEmbeddedLinks *addVideoToReelMessage = [[RTStringWithEmbeddedLinks alloc] init];
            [given([messageSource messageForActivity:addVideoToReelActivity]) willReturn:addVideoToReelMessage];
            
            [presenter retrievedNewsfeed:newsfeed];
            [verify(view) showMessage:createReelMessage forActivityType:RTActivityTypeCreateReel];
            [verify(view) showMessage:addVideoToReelMessage forActivityType:RTActivityTypeAddVideoToReel];
        });
        
        it(@"show message for each activity once", ^{
            RTActivity *activity = [RTActivity createReelActivityWithUser:user reel:reel];
            newsfeed.activities = @[activity];
            
            RTStringWithEmbeddedLinks *message = [[RTStringWithEmbeddedLinks alloc] init];
            [given([messageSource messageForActivity:activity]) willReturn:message];
            
            [presenter retrievedNewsfeed:newsfeed];
            [verify(view) showMessage:message forActivityType:RTActivityTypeCreateReel];
            
            [verify(view) reset];
            
            [presenter retrievedNewsfeed:newsfeed];
            [verifyCount(view, never()) showMessage:message forActivityType:RTActivityTypeCreateReel];
        });
        
        it(@"show message for activity after newsfeed reset", ^{
            RTActivity *activity = [RTActivity createReelActivityWithUser:user reel:reel];
            newsfeed.activities = @[activity];
            
            RTStringWithEmbeddedLinks *message = [[RTStringWithEmbeddedLinks alloc] init];
            [given([messageSource messageForActivity:activity]) willReturn:message];
            
            [presenter retrievedNewsfeed:newsfeed];
            [verify(view) showMessage:message forActivityType:RTActivityTypeCreateReel];
            
            [verify(view) reset];
            [presenter requestedNewsfeedReset];
            
            [presenter retrievedNewsfeed:newsfeed];
            [verify(view) showMessage:message forActivityType:RTActivityTypeCreateReel];
        });
    });
});

SpecEnd
