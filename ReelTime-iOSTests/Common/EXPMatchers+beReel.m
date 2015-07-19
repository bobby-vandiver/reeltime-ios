#import "EXPMatchers+beReel.h"
#import "EXPMatchers+ErrorMessages.h"

#import "RTReel.h"

EXPMatcherImplementationBegin(beReel, (NSNumber *expectedReelId, NSString *expectedName,
                                       NSNumber *expectedAudienceSize, NSNumber *expectedNumberOfVideos,
                                       NSNumber *expectedCurrentUserIsAnAudienceMember)) {
    BOOL actualIsNil = (actual == nil);
    BOOL actualIsReel = [actual isKindOfClass:[RTReel class]];
    
    BOOL expectedReelIdIsNil = (expectedReelId == nil);
    BOOL expectedNameIsNil = (expectedName == nil);
    
    BOOL expectedAudienceSizeIsNil = (expectedAudienceSize == nil);
    BOOL expectedNumberOfVideosIsNil = (expectedNumberOfVideos == nil);
    
    BOOL expectedCurrentUserIsAnAudienceMemberIsNil = (expectedCurrentUserIsAnAudienceMember == nil);
    
    __block RTReel *actualReel;
    
    __block NSNumber *actualReelId;
    __block NSString *actualName;
    
    __block NSNumber *actualAudienceSize;
    __block NSNumber *actualNumberOfVideos;
    
    __block NSNumber *actualCurrentUserIsAnAudienceMember;
    
    __block BOOL sameReelId;
    __block BOOL sameName;
    
    __block BOOL sameAudienceSize;
    __block BOOL sameNumberOfVideos;
    
    __block BOOL sameCurrentUserIsAnAudienceMember;
    
    prerequisite(^BOOL {
        return !(actualIsNil || expectedReelIdIsNil || expectedNameIsNil ||
                 expectedAudienceSizeIsNil || expectedNumberOfVideosIsNil ||
                 expectedCurrentUserIsAnAudienceMemberIsNil);
    });
    
    match(^BOOL {
        if (!actualIsReel) {
            return NO;
        }
        actualReel = (RTReel *)actual;
        
        actualReelId = actualReel.reelId;
        actualName = actualReel.name;
        
        actualAudienceSize = actualReel.audienceSize;
        actualNumberOfVideos = actualReel.numberOfVideos;
        
        actualCurrentUserIsAnAudienceMember = actualReel.currentUserIsAnAudienceMember;
        
        sameReelId = [actualReelId isEqualToNumber:expectedReelId];
        sameName = [actualName isEqualToString:expectedName];
        
        sameAudienceSize = [actualAudienceSize isEqualToNumber:expectedAudienceSize];
        sameNumberOfVideos = [actualNumberOfVideos isEqualToNumber:expectedNumberOfVideos];

        sameCurrentUserIsAnAudienceMember = (actualCurrentUserIsAnAudienceMember.boolValue == expectedCurrentUserIsAnAudienceMember.boolValue);

        return (sameReelId && sameName && sameAudienceSize && sameNumberOfVideos && sameCurrentUserIsAnAudienceMember);
    });
    
    failureMessageForTo(^NSString * {
        if (actualIsNil) {
            return actualValueIsNil();
        }
        if (expectedReelIdIsNil) {
            return expectedValueIsNil(@"reel id");
        }
        if (expectedNameIsNil) {
            return expectedValueIsNil(@"name");
        }
        if (expectedAudienceSizeIsNil) {
            return expectedValueIsNil(@"audience size");
        }
        if (expectedNumberOfVideosIsNil) {
            return expectedValueIsNil(@"number of videos");
        }
        if (expectedCurrentUserIsAnAudienceMemberIsNil) {
            return expectedValueIsNil(@"current user is an audience member");
        }
        if (!actualIsReel) {
            return actualIsNotClass([actual class], [RTReel class]);
        }
        if (!sameReelId) {
            return actualIsNotExpected(@"reel id", actualReelId, expectedReelId);
        }
        if (!sameName) {
            return actualIsNotExpected(@"name", actualName, expectedName);
        }
        if (!sameAudienceSize) {
            return actualIsNotExpected(@"audience size", actualAudienceSize, expectedAudienceSize);
        }
        if (!sameNumberOfVideos) {
            actualIsNotExpected(@"number of videos", actualNumberOfVideos, expectedNumberOfVideos);
        }
        return actualIsNotExpected(@"current user is an audience member", actualCurrentUserIsAnAudienceMember, expectedCurrentUserIsAnAudienceMember);
    });
    
    failureMessageForNotTo(^NSString * {
        if (actualIsNil) {
            return actualValueIsNil();
        }
        if (expectedReelIdIsNil) {
            return expectedValueIsNil(@"reel id");
        }
        if (expectedNameIsNil) {
            return expectedValueIsNil(@"name");
        }
        if (expectedAudienceSizeIsNil) {
            return expectedValueIsNil(@"audience size");
        }
        if (expectedNumberOfVideosIsNil) {
            return expectedValueIsNil(@"number of videos");
        }
        if (expectedCurrentUserIsAnAudienceMemberIsNil) {
            return expectedValueIsNil(@"current user is an audience member");
        }
        if (actualIsReel) {
            return actualIsClass([actual class], [RTReel class]);
        }
        if (sameReelId) {
            return actualIsExpected(@"reel id", actualReelId, expectedReelId);
        }
        if (sameName) {
            return actualIsExpected(@"name", actualName, expectedName);
        }
        if (sameAudienceSize) {
            return actualIsExpected(@"audience size", actualAudienceSize, expectedAudienceSize);
        }
        if (sameNumberOfVideos) {
            actualIsExpected(@"number of videos", actualNumberOfVideos, expectedNumberOfVideos);
        }
        return actualIsExpected(@"current user is an audience member", actualCurrentUserIsAnAudienceMember, expectedCurrentUserIsAnAudienceMember);
    });
}
EXPMatcherImplementationEnd