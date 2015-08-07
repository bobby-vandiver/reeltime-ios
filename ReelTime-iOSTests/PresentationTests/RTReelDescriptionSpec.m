#import "RTTestCommon.h"

#import "RTReelDescription.h"

SpecBegin(RTReelDescription)

describe(@"reel description", ^{
    
    __block RTReelDescription *reelDescription;
    
    RTReelDescription * (^createReelDescription)(NSNumber *) = ^(NSNumber *reelId) {
        return [RTReelDescription reelDescriptionWithName:anything()
                                                forReelId:reelId
                                             audienceSize:anything()
                                           numberOfVideos:anything()
                            currentUserIsAnAudienceMember:anything()
                                            ownerUsername:anything()];
    };
    
    beforeEach(^{
        reelDescription = createReelDescription(@(reelId));
    });
    
    describe(@"isEqual for invalid type", ^{
        it(@"nil", ^{
            BOOL equal = [reelDescription isEqual:nil];
            expect(equal).to.beFalsy();
        });
        
        it(@"non-reel description", ^{
            BOOL equal = [reelDescription isEqual:[NSString string]];
            expect(equal).to.beFalsy();
        });
    });
    
    describe(@"isEqual and hash", ^{
        __block NSUInteger reelDescriptionHash;
        
        beforeEach(^{
            reelDescriptionHash = [reelDescription hash];
        });
        
        it(@"same instance", ^{
            BOOL equal = [reelDescription isEqual:reelDescription];
            expect(equal).to.beTruthy();
        });
        
        it(@"same reelId", ^{
            RTReelDescription *other = createReelDescription(@(reelId));
            
            BOOL equal = [reelDescription isEqual:other];
            expect(equal).to.beTruthy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).to.equal(reelDescriptionHash);
        });
        
        it(@"different reelId", ^{
            RTReelDescription *other = createReelDescription(@(reelId + 1));
            
            BOOL equal = [reelDescription isEqual:other];
            expect(equal).to.beFalsy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).toNot.equal(reelDescriptionHash);
        });
        
        it(@"nil reelId", ^{
            RTReelDescription *other = createReelDescription(nil);
            
            BOOL equal = [reelDescription isEqual:other];
            expect(equal).to.beFalsy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).toNot.equal(reelDescriptionHash);
        });
        
        it(@"both nil reelId", ^{
            RTReelDescription *left = createReelDescription(nil);
            RTReelDescription *right = createReelDescription(nil);
            
            BOOL equal = [left isEqual:right];
            expect(equal).to.beFalsy();
        });
    });
});

SpecEnd
