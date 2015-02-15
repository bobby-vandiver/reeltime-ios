#import "RTTestCommon.h"

#import "NSURL+RTURL.h"

SpecBegin(NSURL_RTURL)

describe(@"NSURL category for reeltime protocol", ^{
    
    describe(@"incorrect protocol", ^{
        it(@"is not a valid reeltime url", ^{
            NSURL *url = [NSURL URLWithString:@"http://something.com"];

            expect(url.isUserURL).to.beFalsy();
            expect(url.username).to.beNil();
            
            expect(url.isReelURL).to.beFalsy();
            expect(url.reelId).to.beNil();
            
            expect(url.isVideoURL).to.beFalsy();
            expect(url.reelId).to.beNil();
        });
    });
    
    describe(@"user url support", ^{
        it(@"is not a user url", ^{
            NSURL *url = [NSURL URLWithString:@"reeltime://foo"];
            expect(url.isUserURL).to.beFalsy();
            expect(url.username).to.beNil();
        });
        
        it(@"is a malformed user url -- username omitted", ^{
            NSURL *url = [NSURL URLWithString:@"reeltime://users/"];
            expect(url.isUserURL).to.beFalsy();
            expect(url.username).to.beNil();
        });
        
        it(@"is a malformed user url -- complex path", ^{
            NSURL *url = [NSURL URLWithString:@"reeltime://users/foo/bar/joe"];
            expect(url.isUserURL).to.beFalsy();
            expect(url.username).to.beNil();
        });
        
        it(@"is a valid user url", ^{
            NSURL *url = [NSURL URLWithString:@"reeltime://users/joe"];
            expect(url.isUserURL).to.beTruthy();
            expect(url.username).to.equal(@"joe");
        });
    });
    
    describe(@"reel url support", ^{
        it(@"is not a reel url", ^{
            NSURL *url = [NSURL URLWithString:@"reeltime://foo"];
            expect(url.isReelURL).to.beFalsy();
            expect(url.reelId).to.beNil();
        });
        
        it(@"is a malformed reel url -- reel id omitted", ^{
            NSURL *url = [NSURL URLWithString:@"reeltime://reels/"];
            expect(url.isReelURL).to.beFalsy();
            expect(url.reelId).to.beFalsy();
        });
        
        it(@"is a malformed reel url -- complex path", ^{
            NSURL *url = [NSURL URLWithString:@"reeltime://reels/foo/bar/derp/1"];
            expect(url.isReelURL).to.beFalsy();
            expect(url.reelId).to.beNil();
        });
        
        it(@"contains invalid reel id", ^{
            NSURL *url = [NSURL URLWithString:@"reeltime://reels/foo"];
            expect(url.isReelURL).to.beFalsy();
            expect(url.reelId).to.beNil();
        });
        
        it(@"is a valid reel url", ^{
            NSString const *URL_KEY = @"url";
            NSString const *REEL_ID_KEY = @"reelId";
            
            NSArray *scenarios = @[
                                   @{ URL_KEY: [NSURL URLWithString:@"reeltime://reels/2"], REEL_ID_KEY: @(2) },
                                   @{ URL_KEY: [NSURL URLWithString:@"reeltime://reels/42"], REEL_ID_KEY: @(42) },
                                   @{ URL_KEY: [NSURL URLWithString:@"reeltime://reels/1234598"], REEL_ID_KEY: @(1234598) }
                                   ];
            
            for (NSDictionary *scenario in scenarios) {
                NSURL *url = scenario[URL_KEY];
                NSNumber *reelId = scenario[REEL_ID_KEY];
                
                expect(url.isReelURL).to.beTruthy();
                expect(url.reelId).to.equal(reelId);
            }
        });
    });
    
    describe(@"video url support", ^{
        it(@"is not a video url", ^{
            NSURL *url = [NSURL URLWithString:@"reeltime://foo"];
            expect(url.isVideoURL).to.beFalsy();
            expect(url.videoId).to.beNil();
        });
        
        it(@"is a malformed video url -- video id omitted", ^{
            NSURL *url = [NSURL URLWithString:@"reeltime://videos/"];
            expect(url.isVideoURL).to.beFalsy();
            expect(url.videoId).to.beNil();
        });

        it(@"is a malformed video url -- complex path", ^{
            NSURL *url = [NSURL URLWithString:@"reeltime://videos/foo/bar/13"];
            expect(url.isVideoURL).to.beFalsy();
            expect(url.videoId).to.beNil();
        });
        
        it(@"contains invalid video id", ^{
            NSURL *url = [NSURL URLWithString:@"reeltime://videos/foo"];
            expect(url.isVideoURL).to.beFalsy();
            expect(url.videoId).to.beNil();
        });
        
        it(@"is a valid video url", ^{
            NSString const *URL_KEY = @"url";
            NSString const *VIDEO_ID_KEY = @"videoId";
            
            NSArray *scenarios = @[
                                   @{ URL_KEY: [NSURL URLWithString:@"reeltime://videos/2"], VIDEO_ID_KEY: @(2) },
                                   @{ URL_KEY: [NSURL URLWithString:@"reeltime://videos/42"], VIDEO_ID_KEY: @(42) },
                                   @{ URL_KEY: [NSURL URLWithString:@"reeltime://videos/1234598"], VIDEO_ID_KEY: @(1234598) }
                                   ];
            
            for (NSDictionary *scenario in scenarios) {
                NSURL *url = scenario[URL_KEY];
                NSNumber *videoId = scenario[VIDEO_ID_KEY];
                
                expect(url.isVideoURL).to.beTruthy();
                expect(url.videoId).to.equal(videoId);
            }
        });
    });
});

SpecEnd