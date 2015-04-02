#import "RTTestCommon.h"

#import "RTActivity.h"

#import "RTUser.h"
#import "RTReel.h"
#import "RTVideo.h"
#import "RTThumbnail.h"

SpecBegin(RTActivity)

describe(@"activity", ^{
    
    __block RTActivity *createReelActivity;
    __block RTActivity *identicalCreateReelActivity;
    
    __block RTActivity *joinReelActivity;
    __block RTActivity *identicalJoinReelActivity;
    
    __block RTActivity *addVideoToReelActivity;
    __block RTActivity *identicalAddVideoToReelActivity;

    __block RTUser *user;
    __block RTUser *identicalUser;
    __block RTUser *differentUser;
    
    __block RTReel *reel;
    __block RTReel *identicalReel;
    __block RTReel *differentReel;
    
    __block RTVideo *video;
    __block RTVideo *identicalVideo;
    __block RTVideo *differentVideo;
    
    __block RTThumbnail *thumbnail;
    
    __block BOOL equal;
    __block NSUInteger hash;
    
    beforeEach(^{
        user = [[RTUser alloc] initWithUsername:username displayName:displayName
                              numberOfFollowers:@(1) numberOfFollowees:@(2)];

        identicalUser = [[RTUser alloc] initWithUsername:[username copy] displayName:[displayName copy]
                                       numberOfFollowers:@(1) numberOfFollowees:@(2)];
        
        differentUser = [[RTUser alloc] initWithUsername:@"different" displayName:displayName
                                       numberOfFollowers:@(1) numberOfFollowees:@(2)];
        
        expect(user).to.equal(identicalUser);
        expect(user).toNot.equal(differentUser);
        
        reel = [[RTReel alloc] initWithReelId:@(1) name:@"reel" audienceSize:@(2) numberOfVideos:@(3)];
        identicalReel = [[RTReel alloc] initWithReelId:@(1) name:@"reel" audienceSize:@(2) numberOfVideos:@(3)];
        differentReel = [[RTReel alloc] initWithReelId:@(1) name:@"different" audienceSize:@(2) numberOfVideos:@(3)];

        expect(reel).to.equal(identicalReel);
        expect(reel).toNot.equal(differentReel);
        
        unsigned char bytes[] = { 0x01 };
        NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
        thumbnail = [[RTThumbnail alloc] initWithData:data];
        
        video = [[RTVideo alloc] initWithVideoId:@(1) title:@"title" thumbnail:thumbnail];
        identicalVideo = [[RTVideo alloc] initWithVideoId:@(1) title:@"title" thumbnail:thumbnail];
        differentVideo = [[RTVideo alloc] initWithVideoId:@(1) title:@"different" thumbnail:thumbnail];

        expect(identicalVideo).to.equal(video);
        expect(video).toNot.equal(differentVideo);
        
        createReelActivity = [RTActivity createReelActivityWithUser:user reel:reel];
        identicalCreateReelActivity = [RTActivity createReelActivityWithUser:identicalUser reel:identicalReel];
        
        joinReelActivity = [RTActivity joinReelActivityWithUser:user reel:reel];
        identicalJoinReelActivity = [RTActivity joinReelActivityWithUser:identicalUser reel:identicalReel];
        
        addVideoToReelActivity = [RTActivity addVideoToReelActivityWithUser:user reel:reel video:video];
        identicalAddVideoToReelActivity = [RTActivity addVideoToReelActivityWithUser:identicalUser reel:identicalReel video:identicalVideo];
    });
    
    describe(@"isEqual for activity with non-activity", ^{
        it(@"nil", ^{
            equal = [createReelActivity isEqual:nil];
            expect(equal).to.beFalsy();
            
            equal = [joinReelActivity isEqual:nil];
            expect(equal).to.beFalsy();
            
            equal = [addVideoToReelActivity isEqual:nil];
            expect(equal).to.beFalsy();
        });
        
        it(@"non-activity", ^{
            equal = [createReelActivity isEqual:[NSString string]];
            expect(equal).to.beFalsy();
            
            equal = [joinReelActivity isEqual:[NSString string]];
            expect(equal).to.beFalsy();
            
            equal = [addVideoToReelActivity isEqual:[NSString string]];
            expect(equal).to.beFalsy();
        });
    });

    describe(@"isEqual and hash for activities", ^{
        __block NSUInteger createReelHash;
        __block NSUInteger joinReelHash;
        __block NSUInteger addVideoToReelHash;
        
        beforeEach(^{
            createReelHash = [createReelActivity hash];
            joinReelHash = [joinReelActivity hash];
            addVideoToReelHash = [addVideoToReelActivity hash];
        });
        
        describe(@"activities are equal", ^{
            it(@"same instance", ^{
                equal = [createReelActivity isEqual:createReelActivity];
                expect(equal).to.beTruthy();
                
                equal = [joinReelActivity isEqual:joinReelActivity];
                expect(equal).to.beTruthy();
                
                equal = [addVideoToReelActivity isEqual:addVideoToReelActivity];
                expect(equal).to.beTruthy();
            });
            
            it(@"different instances, same values", ^{
                equal = [createReelActivity isEqual:identicalCreateReelActivity];
                expect(equal).to.beTruthy();
                
                hash = [identicalCreateReelActivity hash];
                expect(hash).to.equal(createReelHash);
                
                equal = [joinReelActivity isEqual:identicalJoinReelActivity];
                expect(equal).to.beTruthy();
                
                hash = [identicalJoinReelActivity hash];
                expect(hash).to.equal(joinReelHash);
                
                equal = [addVideoToReelActivity isEqual:identicalAddVideoToReelActivity];
                expect(equal).to.beTruthy();
                
                hash = [identicalAddVideoToReelActivity hash];
                expect(hash).to.equal(addVideoToReelHash);
            });
        });
        
        describe(@"activities are not equal", ^{
            
            void (^expectNotEqual)(RTActivity *, RTUser *, RTReel *, RTVideo *) = ^(RTActivity *target,
                                                                                                    RTUser *otherUser,
                                                                                                    RTReel *otherReel,
                                                                                                    RTVideo *otherVideo) {
                RTActivity *otherActivity;
                RTActivityType type = [target.type integerValue];
                
                switch (type) {
                    case RTActivityTypeCreateReel:
                        otherActivity = [RTActivity createReelActivityWithUser:otherUser reel:otherReel];
                        break;
                        
                    case RTActivityTypeJoinReelAudience:
                        otherActivity = [RTActivity joinReelActivityWithUser:otherUser reel:otherReel];
                        break;
                        
                    case RTActivityTypeAddVideoToReel:
                        otherActivity = [RTActivity addVideoToReelActivityWithUser:otherUser reel:otherReel video:otherVideo];
                        break;
                        
                    default:
                        fail();
                };
                
                equal = [target isEqual:otherActivity];
                expect(equal).to.beFalsy();
                
                NSUInteger targetHash = [target hash];
                hash = [otherActivity hash];
                
                expect(hash).toNot.equal(targetHash);
            };
            
            it(@"different types are not equal", ^{
                equal = [createReelActivity isEqual:joinReelActivity];
                expect(equal).to.beFalsy();
                
                equal = [createReelActivity isEqual:addVideoToReelActivity];
                expect(equal).to.beFalsy();
            });
            
            it(@"different types have different hashs", ^{
                expect(createReelHash).toNot.equal(joinReelHash);
                expect(createReelHash).toNot.equal(addVideoToReelHash);
                expect(joinReelHash).toNot.equal(addVideoToReelHash);
            });
            
            it(@"different property values", ^{
                expectNotEqual(createReelActivity, differentUser, identicalReel, nil);
                expectNotEqual(createReelActivity, identicalUser, differentReel, nil);
                
                expectNotEqual(joinReelActivity, differentUser, identicalReel, nil);
                expectNotEqual(joinReelActivity, identicalUser, differentReel, nil);

                expectNotEqual(addVideoToReelActivity, differentUser, identicalReel, identicalVideo);
                expectNotEqual(addVideoToReelActivity, identicalUser, differentReel, identicalVideo);
                expectNotEqual(addVideoToReelActivity, identicalUser, identicalReel, differentVideo);
            });
            
            it(@"nil properties", ^{
                expectNotEqual(createReelActivity, nil, identicalReel, nil);
                expectNotEqual(createReelActivity, identicalUser, nil, nil);
                
                expectNotEqual(joinReelActivity, nil, identicalReel, nil);
                expectNotEqual(joinReelActivity, identicalUser, nil, nil);
                
                expectNotEqual(addVideoToReelActivity, nil, identicalReel, identicalVideo);
                expectNotEqual(addVideoToReelActivity, identicalUser, nil, identicalVideo);
                expectNotEqual(addVideoToReelActivity, identicalUser, identicalReel, nil);
            });
            
            it(@"both have nil properties", ^{
                RTActivity *left = [[RTActivity alloc] init];
                RTActivity *right = [[RTActivity alloc] init];
                
                left.type = nil;
                left.user = nil;
                left.reel = nil;
                left.video = nil;
                
                right.type = nil;
                right.user = nil;
                right.reel = nil;
                right.video = nil;
                
                equal = [left isEqual:right];
                expect(equal).to.beFalsy();
            });
        });
    });
});

SpecEnd