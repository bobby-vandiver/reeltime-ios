#import "RTTestCommon.h"

#import "RTReel.h"

SpecBegin(RTReel)

describe(@"reel", ^{
    
    __block RTReel *reel;
    
    NSNumber *reelId = @(42);
    NSString *name = @"reel name";
    
    NSNumber *audienceSize = @(63);
    NSNumber *numberOfVideos = @(81);

    beforeEach(^{
        reel = [[RTReel alloc] initWithReelId:reelId
                                         name:name
                                 audienceSize:audienceSize
                               numberOfVideos:numberOfVideos];
    });
    
    describe(@"isEqual for reel with non-reel", ^{
        it(@"nil", ^{
            BOOL equal = [reel isEqual:nil];
            expect(equal).to.beFalsy();
        });
        
        it(@"non-reel", ^{
            BOOL equal = [reel isEqual:[NSString string]];
            expect(equal).to.beFalsy();
        });
    });
    
    describe(@"isEqual and hash for reels", ^{
        __block NSUInteger reelHash;
        
        beforeEach(^{
            reelHash = [reel hash];
        });
        
        describe(@"reels are equal", ^{
            it(@"same instance", ^{
                BOOL equal = [reel isEqual:reel];
                expect(equal).to.beTruthy();
            });
            
            it(@"different instances, same property values", ^{
                RTReel *other = [[RTReel alloc] initWithReelId:[reelId copy]
                                                          name:[name copy]
                                                  audienceSize:[audienceSize copy]
                                                numberOfVideos:[numberOfVideos copy]];
                
                BOOL equal = [reel isEqual:other];
                expect(equal).to.beTruthy();
                
                NSUInteger otherHash = [other hash];
                expect(otherHash).to.equal(reelHash);
            });
        });
        
        describe(@"reels are not equal", ^{
            void (^expectNotEqual)(NSNumber *, NSString *, NSNumber *, NSNumber *) = ^(NSNumber *otherReelId,
                                                                                       NSString *otherName,
                                                                                       NSNumber *otherAudienceSize,
                                                                                       NSNumber *otherNumberOfVideos) {
                RTReel *other = [[RTReel alloc] initWithReelId:otherReelId
                                                          name:otherName
                                                  audienceSize:otherAudienceSize
                                                numberOfVideos:otherNumberOfVideos];
                
                BOOL equal = [reel isEqual:other];
                expect(equal).to.beFalsy();
                
                NSUInteger otherHash = [other hash];
                expect(otherHash).toNot.equal(reelHash);
            };
            
            it(@"different property values", ^{
                expectNotEqual(@([reelId intValue] + 1), [name copy],
                               [audienceSize copy], [numberOfVideos copy]);
                
                expectNotEqual([reelId copy], [NSString stringWithFormat:@"%@a", name],
                               [audienceSize copy], [numberOfVideos copy]);
                
                expectNotEqual([reelId copy], [name copy],
                               @([audienceSize intValue] + 1), [numberOfVideos copy]);
                
                expectNotEqual([reelId copy], [name copy],
                               [audienceSize copy], @([numberOfVideos intValue] + 1));
            });
            
            it(@"nil property values", ^{
                expectNotEqual(nil, [name copy],
                               [audienceSize copy], [numberOfVideos copy]);
                
                expectNotEqual([reelId copy], nil,
                               [audienceSize copy], [numberOfVideos copy]);
                
                expectNotEqual([reelId copy], [name copy],
                               nil, [numberOfVideos copy]);
                
                expectNotEqual([reelId copy], [name copy],
                               [audienceSize copy], nil);
            });
            
            it(@"both have nil properties", ^{
                RTReel *left = [[RTReel alloc] initWithReelId:nil name:nil audienceSize:nil numberOfVideos:nil];
                RTReel *right = [[RTReel alloc] initWithReelId:nil name:nil audienceSize:nil numberOfVideos:nil];
                
                BOOL equal = [left isEqual:right];
                expect(equal).to.beFalsy();
            });
        });
    });
});

SpecEnd