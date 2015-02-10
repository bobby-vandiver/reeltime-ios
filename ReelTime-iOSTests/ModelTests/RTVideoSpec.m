#import "RTTestCommon.h"

#import "RTVideo.h"

SpecBegin(RTVideo)

describe(@"video", ^{
    
    __block RTVideo *video;

    NSNumber *videoId = @(1);
    NSString *title = @"title";
    
    beforeEach(^{
        video = [[RTVideo alloc] initWithVideoId:videoId title:title];
    });
    
    describe(@"isEqual for video with non-video", ^{
        it(@"nil", ^{
            BOOL equal = [video isEqual:nil];
            expect(equal).to.beFalsy();
        });
        
        it(@"non-video", ^{
            BOOL equal = [video isEqual:[NSString string]];
            expect(equal).to.beFalsy();
        });
    });

    describe(@"isEqual and hash for videos", ^{
        __block NSUInteger videoHash;
        
        beforeEach(^{
            videoHash = [video hash];
        });
        
        describe(@"videos are equal", ^{
            it(@"same instance", ^{
                BOOL equal = [video isEqual:video];
                expect(equal).to.beTruthy();
            });
            
            it(@"same videoId and title", ^{
                RTVideo *other = [[RTVideo alloc] initWithVideoId:[videoId copy] title:[title copy]];
                
                BOOL equal = [video isEqual:other];
                expect(equal).to.beTruthy();
                
                NSUInteger otherHash = [other hash];
                expect(otherHash).to.equal(videoHash);
            });
        });

        describe(@"videos are not equal", ^{
            void (^expectNotEqual)(NSNumber *, NSString *) = ^(NSNumber *otherVideoId, NSString *otherTitle) {
                RTVideo *other = [[RTVideo alloc] initWithVideoId:otherVideoId title:otherTitle];
                
                BOOL equal = [video isEqual:other];
                expect(equal).to.beFalsy();
                
                NSUInteger otherHash = [other hash];
                expect(otherHash).toNot.equal(videoHash);
            };
            
            it(@"same videoId and different title", ^{
                expectNotEqual([videoId copy], [NSString stringWithFormat:@"%@a", title]);
            });
            
            it(@"different videoId and same title", ^{
                expectNotEqual(@([videoId intValue] + 1), [title copy]);
            });
            
            it(@"nil videoId and same title", ^{
                expectNotEqual(nil, [title copy]);
            });
            
            it(@"same videoId and nil title", ^{
                expectNotEqual([videoId copy], nil);
            });
            
            it(@"both have nil videoId", ^{
                video.videoId = nil;
                expectNotEqual(nil, [title copy]);
            });
            
            it(@"both have nil title", ^{
                video.title = nil;
                expectNotEqual([videoId copy], nil);
            });
            
            it(@"both have nil videoId and nil title", ^{
                RTVideo *left = [[RTVideo alloc] initWithVideoId:nil title:nil];
                RTVideo *right = [[RTVideo alloc] initWithVideoId:nil title:nil];
                
                BOOL equal = [left isEqual:right];
                expect(equal).to.beFalsy();
            });
        });
    });
});

SpecEnd