#import "RTTestCommon.h"

#import "RTVideo.h"
#import "RTThumbnail.h"

SpecBegin(RTVideo)

describe(@"video", ^{
    
    __block RTVideo *video;
    __block RTThumbnail *thumbnail;
    
    __block RTThumbnail *copyThumbnail;
    __block RTThumbnail *differentThumbnail;
    
    NSNumber *videoId = @(1);
    NSString *title = @"title";
    
    beforeEach(^{
        unsigned char bytes[] = { 0x01, 0x02, 0x03, 0x04, 0x05 };

        NSData *thumbnailData = [NSData dataWithBytes:bytes length:sizeof(bytes)];
        thumbnail = [[RTThumbnail alloc] initWithData:thumbnailData];
        
        video = [[RTVideo alloc] initWithVideoId:videoId title:title thumbnail:thumbnail];
        
        copyThumbnail = [[RTThumbnail alloc] initWithData:[thumbnailData copy]];
        
        unsigned char differentBytes[] = { 0x10, 0x11, 0x12, 0x13 };
        NSData *differentThumbnailData = [NSData dataWithBytes:differentBytes length:sizeof(differentBytes)];
        
        differentThumbnail = [[RTThumbnail alloc] initWithData:differentThumbnailData];
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
            
            it(@"same videoId, title and thumbnail", ^{
                RTVideo *other = [[RTVideo alloc] initWithVideoId:[videoId copy] title:[title copy] thumbnail:copyThumbnail];
                
                BOOL equal = [video isEqual:other];
                expect(equal).to.beTruthy();
                
                NSUInteger otherHash = [other hash];
                expect(otherHash).to.equal(videoHash);
            });
        });

        describe(@"videos are not equal", ^{
            void (^expectNotEqual)(NSNumber *, NSString *, RTThumbnail *) = ^(NSNumber *otherVideoId, NSString *otherTitle, RTThumbnail *otherThumbnail) {
                RTVideo *other = [[RTVideo alloc] initWithVideoId:otherVideoId title:otherTitle thumbnail:otherThumbnail];
                
                BOOL equal = [video isEqual:other];
                expect(equal).to.beFalsy();
                
                NSUInteger otherHash = [other hash];
                expect(otherHash).toNot.equal(videoHash);
            };
            
            it(@"same videoId, different title and same thumbnail", ^{
                expectNotEqual([videoId copy], [NSString stringWithFormat:@"%@a", title], copyThumbnail);
            });
            
            it(@"different videoId, same title and same thumbnail", ^{
                expectNotEqual(@([videoId intValue] + 1), [title copy], copyThumbnail);
            });
            
            it(@"same videoId, same title and different thumbnail", ^{
                expectNotEqual([videoId copy], [title copy], differentThumbnail);
            });
            
            it(@"nil videoId, same title and same thumbnail", ^{
                expectNotEqual(nil, [title copy], copyThumbnail);
            });
            
            it(@"same videoId, nil title and same thumbnail", ^{
                expectNotEqual([videoId copy], nil, copyThumbnail);
            });
            
            it(@"both have nil videoId", ^{
                video.videoId = nil;
                expectNotEqual(nil, [title copy], copyThumbnail);
            });
            
            it(@"both have nil title", ^{
                video.title = nil;
                expectNotEqual([videoId copy], nil, copyThumbnail);
            });
            
            it(@"both have nil thumbnail", ^{
                video.thumbnail = nil;
                expectNotEqual([videoId copy], [title copy], nil);
            });
            
            it(@"both have nil videoId, nil title and nil thumbnail", ^{
                RTVideo *left = [[RTVideo alloc] initWithVideoId:nil title:nil thumbnail:nil];
                RTVideo *right = [[RTVideo alloc] initWithVideoId:nil title:nil thumbnail:nil];
                
                BOOL equal = [left isEqual:right];
                expect(equal).to.beFalsy();
            });
        });
    });
});

SpecEnd