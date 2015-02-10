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
        
        it(@"same videoId and different title", ^{
            NSString *differentTitle = [NSString stringWithFormat:@"%@a", title];
            RTVideo *other = [[RTVideo alloc] initWithVideoId:[videoId copy] title:differentTitle];
            
            BOOL equal = [video isEqual:other];
            expect(equal).to.beFalsy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).toNot.equal(videoHash);
        });
        
        it(@"different videoId and same title", ^{
            NSNumber *differentVideoId = @([videoId intValue] + 1);
            RTVideo *other = [[RTVideo alloc] initWithVideoId:differentVideoId title:[title copy]];
            
            BOOL equal = [video isEqual:other];
            expect(equal).to.beFalsy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).toNot.equal(videoHash);
        });
        
        it(@"nil videoId and same title", ^{
            RTVideo *other = [[RTVideo alloc] initWithVideoId:nil title:[title copy]];
            
            BOOL equal = [video isEqual:other];
            expect(equal).to.beFalsy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).toNot.equal(videoHash);
        });
        
        it(@"same videoId and nil title", ^{
            RTVideo *other = [[RTVideo alloc] initWithVideoId:[videoId copy] title:nil];
            
            BOOL equal = [video isEqual:other];
            expect(equal).to.beFalsy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).toNot.equal(videoHash);
        });
        
        it(@"both have nil videoId", ^{
            RTVideo *other = [[RTVideo alloc] initWithVideoId:nil title:[title copy]];
            video.videoId = nil;
            
            BOOL equal = [video isEqual:other];
            expect(equal).to.beFalsy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).toNot.equal(videoHash);
        });
        
        it(@"both have nil title", ^{
            RTVideo *other = [[RTVideo alloc] initWithVideoId:[videoId copy] title:nil];
            video.title = nil;
            
            BOOL equal = [video isEqual:other];
            expect(equal).to.beFalsy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).toNot.equal(videoHash);
        });
        
        it(@"both have nil videoId and nil title", ^{
            RTVideo *left = [[RTVideo alloc] initWithVideoId:nil title:nil];
            RTVideo *right = [[RTVideo alloc] initWithVideoId:nil title:nil];
            
            BOOL equal = [left isEqual:right];
            expect(equal).to.beFalsy();
        });
    });
});

SpecEnd