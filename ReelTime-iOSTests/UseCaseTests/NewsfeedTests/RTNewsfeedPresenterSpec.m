#import "RTTestCommon.h"

#import "RTNewsfeedPresenter.h"

#import "RTNewsfeedView.h"
#import "RTNewsfeedInteractor.h"
#import "RTNewsfeedWireframe.h"

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
        __block MKTArgumentCaptor *captor;
        
        __block RTUser *user;
        __block RTReel *reel;
        __block RTVideo *video;
        
        beforeEach(^{
            newsfeed = [[RTNewsfeed alloc] init];
            captor = [[MKTArgumentCaptor alloc] init];
            
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
            
            [presenter retrievedNewsfeed:newsfeed];
            [verify(view) showMessage:[captor capture] forActivityType:RTActivityTypeCreateReel];
            
            NSString *expected = [NSString stringWithFormat:@"%@ created the %@ reel", user.username, reel.name];

            RTStringWithEmbeddedLinks *message = [captor value];
            expect(message.string).to.equal(expected);
            
            expect(message.embeddedURLs.count).to.equal(2);
            
            NSString *userUrl = [NSString stringWithFormat:@"reeltime://users/%@", user.username];
            NSString *reelUrl = [NSString stringWithFormat:@"reeltime://reels/%@", reel.reelId];
            
            RTEmbeddedURL *url = [message.embeddedURLs objectAtIndex:0];
            expect(url.url).to.equal([NSURL URLWithString:userUrl]);
            
            url = [message.embeddedURLs objectAtIndex:1];
            expect(url.url).to.equal([NSURL URLWithString:reelUrl]);
        });
    });
});

SpecEnd
