#import "RTTestCommon.h"

#import "RTVideo.h"
#import "RTThumbnail.h"

SpecBegin(RTVideo)

describe(@"video", ^{
    
    __block RTVideo *video;
    __block RTThumbnail *thumbnail;
    
    NSNumber *videoId = @(1);
    NSString *title = @"title";
    
    beforeEach(^{
        unsigned char bytes[] = { 0x01, 0x02, 0x03, 0x04, 0x05 };

        NSData *thumbnailData = [NSData dataWithBytes:bytes length:sizeof(bytes)];
        thumbnail = [[RTThumbnail alloc] initWithData:thumbnailData];
        
        video = [[RTVideo alloc] initWithVideoId:videoId title:title thumbnail:thumbnail];
    });
    
    describe(@"description", ^{
        it(@"includes video id, title and thumbnail hash", ^{
            NSString *expected = [NSString stringWithFormat:@"{videoId: 1, title: title, thumbnail: %lu}",
                                  (unsigned long)thumbnail.hash];
            
            expect([video description]).to.equal(expected);
        });
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
                RTVideo *other = [[RTVideo alloc] initWithVideoId:[videoId copy] title:[title copy] thumbnail:[thumbnail copy]];
                
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

            it(@"different videoId, same title and same thumbnail", ^{
                expectNotEqual(@([videoId intValue] + 1), [title copy], [thumbnail copy]);
            });
            
            it(@"nil videoId, same title and same thumbnail", ^{
                expectNotEqual(nil, [title copy], [thumbnail copy]);
            });
            
            it(@"both have nil videoId", ^{
                video.videoId = nil;
                expectNotEqual(nil, [title copy], [thumbnail copy]);
            });
        });
    });
});

SpecEnd