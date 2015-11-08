#import "RTTestCommon.h"

#import "RTReel.h"
#import "RTUser.h"

SpecBegin(RTReel)

describe(@"reel", ^{
    
    __block RTReel *reel;

    NSNumber *reelId = @(42);
    NSString *name = @"reel name";
    
    NSNumber *audienceSize = @(63);
    NSNumber *numberOfVideos = @(81);
    
    NSNumber *currentUserIsAnAudienceMember = @(YES);

    beforeEach(^{
        reel = [[RTReel alloc] initWithReelId:reelId
                                         name:name
                                 audienceSize:audienceSize
                               numberOfVideos:numberOfVideos
                currentUserIsAnAudienceMember:currentUserIsAnAudienceMember
                                        owner:nil];
    });
    
    describe(@"description", ^{       
        it(@"should include all fields", ^{
            NSString *expectedBeginning = @"{reelId: 42, name: reel name, audienceSize: 63, numberOfVideos: 81, currentUserIsAnAudienceMember: YES, owner: ";
            NSString *expectedEnding = @"}";
            
            NSString *actual = [reel description];
            expect(actual).to.beginWith(expectedBeginning);
            expect(actual).to.endWith(expectedEnding);
        });
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
                                                numberOfVideos:[numberOfVideos copy]
                                 currentUserIsAnAudienceMember:[currentUserIsAnAudienceMember copy]
                                                         owner:nil];
                
                BOOL equal = [reel isEqual:other];
                expect(equal).to.beTruthy();
                
                NSUInteger otherHash = [other hash];
                expect(otherHash).to.equal(reelHash);
            });
        });
        
        describe(@"reels are not equal", ^{
            void (^expectNotEqual)(NSNumber *, NSString *, NSNumber *, NSNumber *, NSNumber *) =

            ^(NSNumber *otherReelId, NSString *otherName, NSNumber *otherAudienceSize,
              NSNumber *otherNumberOfVideos, NSNumber *otherCurrentUserIsAnAudienceMember) {
                
                RTReel *other = [[RTReel alloc] initWithReelId:otherReelId
                                                          name:otherName
                                                  audienceSize:otherAudienceSize
                                                numberOfVideos:otherNumberOfVideos
                                 currentUserIsAnAudienceMember:otherCurrentUserIsAnAudienceMember
                                                         owner:nil];
                
                BOOL equal = [reel isEqual:other];
                expect(equal).to.beFalsy();
                
                NSUInteger otherHash = [other hash];
                expect(otherHash).toNot.equal(reelHash);
            };
            
            it(@"different reel id", ^{
                expectNotEqual(@([reelId intValue] + 1), [name copy],
                               [audienceSize copy], [numberOfVideos copy],
                               [currentUserIsAnAudienceMember copy]);
            });
            
            it(@"nil reel id", ^{
                expectNotEqual(nil, [name copy],
                               [audienceSize copy], [numberOfVideos copy],
                               [currentUserIsAnAudienceMember copy]);
            });
            
            it(@"both have nil reel id", ^{
                RTReel *left = [[RTReel alloc] initWithReelId:nil
                                                         name:name
                                                 audienceSize:audienceSize
                                               numberOfVideos:numberOfVideos
                                currentUserIsAnAudienceMember:currentUserIsAnAudienceMember
                                                        owner:nil];

                RTReel *right = [[RTReel alloc] initWithReelId:nil
                                                          name:[name copy]
                                                  audienceSize:[audienceSize copy]
                                                numberOfVideos:[numberOfVideos copy]
                                 currentUserIsAnAudienceMember:[currentUserIsAnAudienceMember copy]
                                                         owner:nil];
                
                BOOL equal = [left isEqual:right];
                expect(equal).to.beFalsy();
            });
        });
    });
});

SpecEnd