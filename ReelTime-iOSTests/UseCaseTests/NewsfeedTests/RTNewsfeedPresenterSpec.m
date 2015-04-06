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
#import "RTThumbnail.h"

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
        
        reel = [[RTReel alloc] initWithReelId:@(1) name:@"reel" audienceSize:@(2) numberOfVideos:@(3) owner:nil];
        
        RTThumbnail *thumbnail = mock([RTThumbnail class]);
        video = [[RTVideo alloc] initWithVideoId:@(1) title:@"title" thumbnail:thumbnail];
    });
    
    describe(@"newsfeed reset", ^{
        it(@"should notify view that currently displayed messages should be removed", ^{
            [presenter clearPresentedItems];
            [verify(view) clearMessages];
        });
    });
    
    describe(@"show newsfeed activities", ^{
        it(@"should show activity message", ^{
            RTActivity *activity = [[RTActivity alloc] init];
            
            RTActivityMessage *message = [[RTActivityMessage alloc] init];
            [given([messageSource messageForActivity:activity]) willReturn:message];
            
            [presenter presentItem:activity];
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
            [verify(wireframe) presentReelForReelId:reel.reelId ownerUsername:@""];
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
            [verifyCount(wireframe, never()) presentReelForReelId:anything() ownerUsername:anything()];
            [verifyCount(wireframe, never()) presentVideoForVideoId:anything()];
        });
    });
});

SpecEnd
