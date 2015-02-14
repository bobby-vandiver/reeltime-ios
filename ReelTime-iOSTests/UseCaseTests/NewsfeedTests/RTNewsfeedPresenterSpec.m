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

    beforeEach(^{
        view = mockProtocol(@protocol(RTNewsfeedView));
        interactor = mock([RTNewsfeedInteractor class]);
        wireframe = mock([RTNewsfeedWireframe class]);
        
        RTNewsfeedMessageSource *messageSource = [[RTNewsfeedMessageSource alloc] init];
        
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
        __block MKTArgumentCaptor *captor;

        __block RTActivity *activity;
        __block RTStringWithEmbeddedLinks *message;

        __block RTEmbeddedURL *link;
        __block NSString *linkText;
        
        __block RTUser *user;
        __block RTReel *reel;
        __block RTVideo *video;
        
        __block NSURL *userURL;
        __block NSURL *reelURL;
        __block NSURL *videoURL;
        
        beforeEach(^{
            newsfeed = [[RTNewsfeed alloc] init];
            captor = [[MKTArgumentCaptor alloc] init];
            
            user = [[RTUser alloc] initWithUsername:username displayName:displayName
                                  numberOfFollowers:@(1) numberOfFollowees:@(2)];

            reel = [[RTReel alloc] initWithReelId:@(1) name:@"reel" audienceSize:@(2) numberOfVideos:@(3)];

            video = [[RTVideo alloc] initWithVideoId:@(1) title:@"title"];
            
            userURL = [NSURL URLWithString:[NSString stringWithFormat:@"reeltime://users/%@", user.username]];
            reelURL = [NSURL URLWithString:[NSString stringWithFormat:@"reeltime://reels/%@", reel.reelId]];
            videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"reeltime://videos/%@", video.videoId]];
        });
        
        it(@"no activities to show", ^{
            newsfeed.activities = @[];
            [presenter retrievedNewsfeed:newsfeed];
            [verifyCount(view, never()) showMessage:anything() forActivityType:0];
        });
        
        it(@"show create reel activity", ^{
            activity = [RTActivity createReelActivityWithUser:user reel:reel];
            newsfeed.activities = @[activity];
            
            [presenter retrievedNewsfeed:newsfeed];
            [verify(view) showMessage:[captor capture] forActivityType:RTActivityTypeCreateReel];
            
            NSString *expected = [NSString stringWithFormat:@"%@ created the %@ reel",
                                  user.username, reel.name];

            message = [captor value];
            expect(message.string).to.equal(expected);
            expect(message.links.count).to.equal(2);
            
            link = [message.links objectAtIndex:0];
            expect(link.url).to.equal(userURL);

            linkText = [message.string substringWithRange:link.range];
            expect(linkText).to.equal(user.username);
            
            link = [message.links objectAtIndex:1];
            expect(link.url).to.equal(reelURL);
            
            linkText = [message.string substringWithRange:link.range];
            expect(linkText).to.equal(reel.name);
        });

        it(@"show join reel activity", ^{
            activity = [RTActivity joinReelActivityWithUser:user reel:reel];
            newsfeed.activities= @[activity];
            
            [presenter retrievedNewsfeed:newsfeed];
            [verify(view) showMessage:[captor capture] forActivityType:RTActivityTypeJoinReelAudience];
            
            NSString *expected = [NSString stringWithFormat:@"%@ joined the audience of the %@ reel",
                                  user.username, reel.name];
            
            message = [captor value];
            expect(message.string).to.equal(expected);
            expect(message.links.count).to.equal(2);
            
            link = [message.links objectAtIndex:0];
            expect(link.url).to.equal(userURL);
            
            linkText = [message.string substringWithRange:link.range];
            expect(linkText).to.equal(user.username);
            
            link = [message.links objectAtIndex:1];
            expect(link.url).to.equal(reelURL);
            
            linkText = [message.string substringWithRange:link.range];
            expect(linkText).to.equal(reel.name);
        });
        
        it(@"show add video to reel activity", ^{
            activity = [RTActivity addVideoToReelActivityWithUser:user reel:reel video:video];
            newsfeed.activities = @[activity];
            
            [presenter retrievedNewsfeed:newsfeed];
            [verify(view) showMessage:[captor capture] forActivityType:RTActivityTypeAddVideoToReel];
            
            NSString *expected = [NSString stringWithFormat:@"%@ added the video %@ to the %@ reel",
                                  user.username, video.title, reel.name];

            message = [captor value];
            expect(message.string).to.equal(expected);
            expect(message.links.count).to.equal(3);
            
            link = [message.links objectAtIndex:0];
            expect(link.url).to.equal(userURL);
            
            linkText = [message.string substringWithRange:link.range];
            expect(linkText).to.equal(user.username);
            
            link = [message.links objectAtIndex:1];
            expect(link.url).to.equal(reelURL);
            
            linkText = [message.string substringWithRange:link.range];
            expect(linkText).to.equal(reel.name);

            link = [message.links objectAtIndex:2];
            expect(link.url).to.equal(videoURL);
            
            linkText = [message.string substringWithRange:link.range];
            expect(linkText).to.equal(video.title);
        });
    });
});

SpecEnd
