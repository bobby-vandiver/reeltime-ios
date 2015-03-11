#import "RTTestCommon.h"

#import "RTNewsfeedPresenter.h"

#import "RTNewsfeedView.h"
#import "RTPagedListInteractor.h"
#import "RTNewsfeedWireframe.h"
#import "RTNewsfeedMessageSource.h"

#import "RTNewsfeed.h"
#import "RTActivity.h"

#import "RTUser.h"
#import "RTReel.h"
#import "RTVideo.h"

#import "RTActivityMessage.h"
#import "RTURLFactory.h"

SpecBegin(RTNewsfeedPresenter)

describe(@"newsfeed presenter", ^{

    __block RTNewsfeedPresenter *presenter;

    __block id<RTNewsfeedView> view;
    __block RTPagedListInteractor *interactor;
    __block RTNewsfeedWireframe *wireframe;
    __block RTNewsfeedMessageSource *messageSource;
    
    __block RTUser *user;
    __block RTReel *reel;
    __block RTVideo *video;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTNewsfeedView));
        interactor = mock([RTPagedListInteractor class]);
        wireframe = mock([RTNewsfeedWireframe class]);
        messageSource = mock([RTNewsfeedMessageSource class]);
        
        presenter = [[RTNewsfeedPresenter alloc] initWithView:view
                                                   interactor:interactor
                                                    wireframe:wireframe
                                                messageSource:messageSource];
        
        user = [[RTUser alloc] initWithUsername:username displayName:displayName
                              numberOfFollowers:@(1) numberOfFollowees:@(2)];
        
        reel = [[RTReel alloc] initWithReelId:@(1) name:@"reel" audienceSize:@(2) numberOfVideos:@(3)];
        
        video = [[RTVideo alloc] initWithVideoId:@(1) title:@"title"];
    });
    
    describe(@"newsfeed page requested", ^{
        it(@"should always get the next requested page", ^{
            [presenter requestedNextNewsfeedPage];
            [verify(interactor) listPage:1];
            
            [presenter requestedNextNewsfeedPage];
            [verify(interactor) listPage:2];
            
            [presenter requestedNextNewsfeedPage];
            [verify(interactor) listPage:3];
        });
    });
    
    describe(@"newsfeed reset", ^{
        it(@"should reset page counter so the first page is retrieved next", ^{
            [presenter requestedNextNewsfeedPage];
            [verify(interactor) listPage:1];
            
            [presenter requestedNextNewsfeedPage];
            [verify(interactor) listPage:2];

            [presenter requestedNewsfeedReset];
            [verify(interactor) reset];
            
            [presenter requestedNextNewsfeedPage];
            [verify(interactor) listPage:1];
        });
        
        it(@"should notify view that currently displayed messages should be removed", ^{
            [presenter requestedNewsfeedReset];
            [verify(view) clearMessages];
        });
    });
    
    describe(@"show newsfeed page activities", ^{
        __block RTNewsfeed *newsfeed;

        beforeEach(^{
            newsfeed = [[RTNewsfeed alloc] init];
        });
        
        it(@"no activities to show", ^{
            newsfeed.activities = @[];
            [presenter retrievedListPage:newsfeed];
            [verifyCount(view, never()) showMessage:anything()];
        });
       
        it(@"show create reel activity", ^{
            RTActivity *activity = [RTActivity createReelActivityWithUser:user reel:reel];
            newsfeed.activities = @[activity];
            
            RTActivityMessage *message = [[RTActivityMessage alloc] init];
            [given([messageSource messageForActivity:activity]) willReturn:message];
            
            [presenter retrievedListPage:newsfeed];
            [verify(view) showMessage:message];
        });
        
        it(@"show join reel activity", ^{
            RTActivity *activity = [RTActivity joinReelActivityWithUser:user reel:reel];
            newsfeed.activities= @[activity];

            RTActivityMessage *message = [[RTActivityMessage alloc] init];
            [given([messageSource messageForActivity:activity]) willReturn:message];

            [presenter retrievedListPage:newsfeed];
            [verify(view) showMessage:message];
        });
        
        it(@"show add video to reel activity", ^{
            RTActivity *activity = [RTActivity addVideoToReelActivityWithUser:user reel:reel video:video];
            newsfeed.activities = @[activity];

            RTActivityMessage *message = [[RTActivityMessage alloc] init];
            [given([messageSource messageForActivity:activity]) willReturn:message];
            
            [presenter retrievedListPage:newsfeed];
            [verify(view) showMessage:message];
        });
        
        it(@"show multiple activities", ^{
            RTActivity *createReelActivity = [RTActivity createReelActivityWithUser:user reel:reel];
            RTActivity *addVideoToReelActivity = [RTActivity addVideoToReelActivityWithUser:user reel:reel video:video];
            
            newsfeed.activities = @[createReelActivity, addVideoToReelActivity];
            
            RTActivityMessage *createReelMessage = [[RTActivityMessage alloc] init];
            [given([messageSource messageForActivity:createReelActivity]) willReturn:createReelMessage];
            
            RTActivityMessage *addVideoToReelMessage = [[RTActivityMessage alloc] init];
            [given([messageSource messageForActivity:addVideoToReelActivity]) willReturn:addVideoToReelMessage];
            
            [presenter retrievedListPage:newsfeed];
            [verify(view) showMessage:createReelMessage];
            [verify(view) showMessage:addVideoToReelMessage];
        });
        
        it(@"show message for each activity once", ^{
            RTActivity *activity = [RTActivity createReelActivityWithUser:user reel:reel];
            newsfeed.activities = @[activity];
            
            RTActivityMessage *message = [[RTActivityMessage alloc] init];
            [given([messageSource messageForActivity:activity]) willReturn:message];
            
            [presenter retrievedListPage:newsfeed];
            [verify(view) showMessage:message];
            
            [verify(view) reset];
            
            [presenter retrievedListPage:newsfeed];
            [verifyCount(view, never()) showMessage:message];
        });
        
        it(@"show message for activity after newsfeed reset", ^{
            RTActivity *activity = [RTActivity createReelActivityWithUser:user reel:reel];
            newsfeed.activities = @[activity];
            
            RTActivityMessage *message = [[RTActivityMessage alloc] init];
            [given([messageSource messageForActivity:activity]) willReturn:message];
            
            [presenter retrievedListPage:newsfeed];
            [verify(view) showMessage:message];
            
            [verify(view) reset];
            [presenter requestedNewsfeedReset];
            
            [presenter retrievedListPage:newsfeed];
            [verify(view) showMessage:message];
        });
    });
    
    describe(@"routing to other modules", ^{
        it(@"should present user when user link is selected", ^{
            NSURL *url = [RTURLFactory URLForUser:user];

            [presenter attributedLabel:anything() didSelectLinkWithURL:url];
            [verify(wireframe) presentUserForUsername:user.username];
        });
        
        it(@"should present reel when reel link is selected", ^{
            NSURL *url = [RTURLFactory URLForReel:reel];
            
            [presenter attributedLabel:anything() didSelectLinkWithURL:url];
            [verify(wireframe) presentReelForReelId:reel.reelId];
        });
        
        it(@"should present video when video link is selected", ^{
            NSURL *url = [RTURLFactory URLForVideo:video];
            
            [presenter attributedLabel:anything() didSelectLinkWithURL:url];
            [verify(wireframe) presentVideoForVideoId:video.videoId];
        });
        
        it(@"should do nothing when unknown link is selected", ^{
            NSURL *url = [NSURL URLWithString:@"http://something.com/"];
            [presenter attributedLabel:anything() didSelectLinkWithURL:url];
            
            [verifyCount(wireframe, never()) presentUserForUsername:anything()];
            [verifyCount(wireframe, never()) presentReelForReelId:anything()];
            [verifyCount(wireframe, never()) presentVideoForVideoId:anything()];
        });
    });
});

SpecEnd
