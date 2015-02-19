#import "RTTestCommon.h"

#import "RTURLFactory.h"

#import "RTUser.h"
#import "RTReel.h"
#import "RTVideo.h"

SpecBegin(RTURLFactory)

describe(@"url factory", ^{
    
    it(@"user url", ^{
        RTUser *user = [[RTUser alloc] initWithUsername:@"joe" displayName:displayName
                                      numberOfFollowers:@(1) numberOfFollowees:@(2)];
        
        NSURL *userURL = [NSURL URLWithString:@"reeltime://users/joe"];
        
        NSURL *url = [RTURLFactory URLForUser:user];
        expect(url).to.equal(userURL);
    });

    it(@"reel url", ^{
        RTReel *reel = [[RTReel alloc] initWithReelId:@(5) name:@"reel" audienceSize:@(2) numberOfVideos:@(3)];
        NSURL *reelURL = [NSURL URLWithString:@"reeltime://reels/5"];
        
        NSURL *url = [RTURLFactory URLForReel:reel];
        expect(url).to.equal(reelURL);
    });
    
    it(@"video url", ^{
        RTVideo *video = [[RTVideo alloc] initWithVideoId:@(31) title:@"title"];
        NSURL *videoURL = [NSURL URLWithString:@"reeltime://videos/31"];
        
        NSURL *url = [RTURLFactory URLForVideo:video];
        expect(url).to.equal(videoURL);
    });
});

SpecEnd