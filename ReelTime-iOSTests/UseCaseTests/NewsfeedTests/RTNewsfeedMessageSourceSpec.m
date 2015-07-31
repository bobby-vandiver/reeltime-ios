#import "RTTestCommon.h"

#import "RTNewsfeedMessageSource.h"
#import "RTActivityMessage.h"

#import "RTActivity.h"

#import "RTUser.h"
#import "RTReel.h"
#import "RTVideo.h"
#import "RTThumbnail.h"

SpecBegin(RTNewsfeedMessageSource)

describe(@"newsfeed message source", ^{

    __block RTNewsfeedMessageSource *messageSource;
    
    __block RTUser *user;
    __block RTReel *reel;
    __block RTVideo *video;

    beforeEach(^{
        messageSource = [[RTNewsfeedMessageSource alloc] init];
        
        user = [[RTUser alloc] initWithUsername:username
                                    displayName:displayName
                              numberOfFollowers:@(1)
                              numberOfFollowees:@(2)
                             numberOfReelsOwned:@(3)
                    numberOfAudienceMemberships:@(4)
                         currentUserIsFollowing:@(YES)];
        
        reel = [[RTReel alloc] initWithReelId:@(1)
                                         name:@"reel"
                                 audienceSize:@(2)
                               numberOfVideos:@(3)
                currentUserIsAnAudienceMember:@(YES)
                                        owner:nil];
        
        RTThumbnail *thumbnail = mock([RTThumbnail class]);
        video = [[RTVideo alloc] initWithVideoId:@(1) title:@"title" thumbnail:thumbnail];
    });
    
    describe(@"creating activity type specific messages", ^{
        it(@"create reel activity", ^{
            RTActivity *activity = [RTActivity createReelActivityWithUser:user reel:reel];
            
            NSString *expected = [NSString stringWithFormat:@"%@ created the %@ reel",
                                  user.username, reel.name];
            
            RTActivityMessage *activityMessage = [messageSource messageForActivity:activity];
            
            expect(activityMessage.type).to.equal(RTActivityTypeCreateReel);
            expect(activityMessage.text).to.equal(expected);

            expect(activityMessage.username).to.equal(user.username);
            expect(activityMessage.reelId).to.equal(reel.reelId);
            expect(activityMessage.videoId).to.beNil();
        });
        
        it(@"join reel activity", ^{
            RTActivity *activity = [RTActivity joinReelActivityWithUser:user reel:reel];

            NSString *expected = [NSString stringWithFormat:@"%@ joined the audience of the %@ reel",
                                  user.username, reel.name];
            
            RTActivityMessage *activityMessage = [messageSource messageForActivity:activity];
            
            expect(activityMessage.type).to.equal(RTActivityTypeJoinReelAudience);
            expect(activityMessage.text).to.equal(expected);
            
            expect(activityMessage.username).to.equal(user.username);
            expect(activityMessage.reelId).to.equal(reel.reelId);
            expect(activityMessage.videoId).to.beNil();
        });
        
        it(@"add video to reel activity", ^{
            RTActivity *activity = [RTActivity addVideoToReelActivityWithUser:user reel:reel video:video];
            
            NSString *expected = [NSString stringWithFormat:@"%@ added the video %@ to the %@ reel",
                                  user.username, video.title, reel.name];
            
            RTActivityMessage *activityMessage = [messageSource messageForActivity:activity];
            
            expect(activityMessage.type).to.equal(RTActivityTypeAddVideoToReel);
            expect(activityMessage.text).to.equal(expected);
            
            expect(activityMessage.username).to.equal(user.username);
            expect(activityMessage.reelId).to.equal(reel.reelId);
            expect(activityMessage.videoId).to.equal(video.videoId);
        });
    });
});

SpecEnd