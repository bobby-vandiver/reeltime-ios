#import "RTTestCommon.h"

#import "RTNewsfeedMessageSource.h"
#import "RTActivityMessage.h"

#import "RTActivity.h"

#import "RTUser.h"
#import "RTReel.h"
#import "RTVideo.h"
#import "RTThumbnail.h"

#import "RTStringWithEmbeddedLinks.h"
#import "RTEmbeddedURL.h"

SpecBegin(RTNewsfeedMessageSource)

describe(@"newsfeed message source", ^{

    __block RTNewsfeedMessageSource *messageSource;
    
    __block RTUser *user;
    __block RTReel *reel;
    __block RTVideo *video;
    
    __block NSURL *userURL;
    __block NSURL *reelURL;
    __block NSURL *videoURL;

    beforeEach(^{
        messageSource = [[RTNewsfeedMessageSource alloc] init];
        
        user = [[RTUser alloc] initWithUsername:username displayName:displayName
                              numberOfFollowers:@(1) numberOfFollowees:@(2)];
        
        reel = [[RTReel alloc] initWithReelId:@(1) name:@"reel" audienceSize:@(2) numberOfVideos:@(3) owner:nil];
        
        RTThumbnail *thumbnail = mock([RTThumbnail class]);
        video = [[RTVideo alloc] initWithVideoId:@(1) title:@"title" thumbnail:thumbnail];
        
        userURL = [NSURL URLWithString:[NSString stringWithFormat:@"reeltime://users/%@", user.username]];
        reelURL = [NSURL URLWithString:[NSString stringWithFormat:@"reeltime://reels/%@", reel.reelId]];
        videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"reeltime://videos/%@", video.videoId]];
    });
    
    describe(@"creating activity type specific messages", ^{
        it(@"create reel activity", ^{
            RTActivity *activity = [RTActivity createReelActivityWithUser:user reel:reel];
            
            NSString *expected = [NSString stringWithFormat:@"%@ created the %@ reel",
                                  user.username, reel.name];
            
            RTActivityMessage *activityMessage = [messageSource messageForActivity:activity];
            expect(activityMessage.type).to.equal(RTActivityTypeCreateReel);

            RTStringWithEmbeddedLinks *message = activityMessage.message;
            expect(message.string).to.equal(expected);
            expect(message.links.count).to.equal(2);
            
            RTEmbeddedURL *link = [message.links objectAtIndex:0];
            expect(link.url).to.equal(userURL);
            
            NSString *linkText = [message.string substringWithRange:link.range];
            expect(linkText).to.equal(user.username);
            
            link = [message.links objectAtIndex:1];
            expect(link.url).to.equal(reelURL);
            
            linkText = [message.string substringWithRange:link.range];
            expect(linkText).to.equal(reel.name);
        });
        
        it(@"join reel activity", ^{
            RTActivity *activity = [RTActivity joinReelActivityWithUser:user reel:reel];

            NSString *expected = [NSString stringWithFormat:@"%@ joined the audience of the %@ reel",
                                  user.username, reel.name];
            
            RTActivityMessage *activityMessage = [messageSource messageForActivity:activity];
            expect(activityMessage.type).to.equal(RTActivityTypeJoinReelAudience);
            
            RTStringWithEmbeddedLinks *message = activityMessage.message;
            expect(message.string).to.equal(expected);
            expect(message.links.count).to.equal(2);
            
            RTEmbeddedURL *link = [message.links objectAtIndex:0];
            expect(link.url).to.equal(userURL);
            
            NSString *linkText = [message.string substringWithRange:link.range];
            expect(linkText).to.equal(user.username);
            
            link = [message.links objectAtIndex:1];
            expect(link.url).to.equal(reelURL);
            
            linkText = [message.string substringWithRange:link.range];
            expect(linkText).to.equal(reel.name);
        });
        
        it(@"add video to reel activity", ^{
            RTActivity *activity = [RTActivity addVideoToReelActivityWithUser:user reel:reel video:video];
            
            NSString *expected = [NSString stringWithFormat:@"%@ added the video %@ to the %@ reel",
                                  user.username, video.title, reel.name];
            
            RTActivityMessage *activityMessage = [messageSource messageForActivity:activity];
            expect(activityMessage.type).to.equal(RTActivityTypeAddVideoToReel);
            
            RTStringWithEmbeddedLinks *message = activityMessage.message;
            expect(message.string).to.equal(expected);
            expect(message.links.count).to.equal(3);
            
            RTEmbeddedURL *link = [message.links objectAtIndex:0];
            expect(link.url).to.equal(userURL);
            
            NSString *linkText = [message.string substringWithRange:link.range];
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