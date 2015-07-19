#import "EXPMatchers+beUser.h"
#import "EXPMatchers+ErrorMessages.h"

#import "RTUser.h"

EXPMatcherImplementationBegin(beUser, (NSString *expectedUsername, NSString *expectedDisplayName,
                                       NSNumber *expectedNumberOfFollowers, NSNumber *expectedNumberOfFollowees,
                                       NSNumber *expectedNumberOfReelsOwned, NSNumber *expectedNumberOfAudienceMemberships,
                                       NSNumber *expectedCurrentUserIsFollowing)) {
    BOOL actualIsNil = (actual == nil);
    BOOL actualIsUser = [actual isKindOfClass:[RTUser class]];
    
    BOOL expectedUsernameIsNil = (expectedUsername == nil);
    BOOL expectedDisplayNameIsNil = (expectedDisplayName == nil);
    
    BOOL expectedNumberOfFollowersIsNil = (expectedNumberOfFollowers == nil);
    BOOL expectedNumberOfFolloweesIsNil = (expectedNumberOfFollowees == nil);
    
    BOOL expectedNumberOfReelsOwnedIsNil = (expectedNumberOfReelsOwned == nil);
    BOOL expectedNumberOfAudienceMembershipsIsNil = (expectedNumberOfAudienceMemberships == nil);

    BOOL expectedCurrentUserIsFollowingIsNil = (expectedCurrentUserIsFollowing == nil);

    __block RTUser *actualUser;
    
    __block NSString *actualUsername;
    __block NSString *actualDisplayName;
    
    __block NSNumber *actualNumberOfFollowers;
    __block NSNumber *actualNumberOfFollowees;
    
    __block NSNumber *actualNumberOfReelsOwned;
    __block NSNumber *actualNumberOfAudienceMemberships;
    
    __block NSNumber *actualCurrentUserIsFollowing;
    
    __block BOOL sameUsername;
    __block BOOL sameDisplayName;

    __block BOOL sameNumberOfFollowers;
    __block BOOL sameNumberOfFollowees;
    
    __block BOOL sameNumberOfReelsOwned;
    __block BOOL sameNumberOfAudienceMemberships;
    
    __block BOOL sameCurrentUserIsFollowing;

    prerequisite(^BOOL {
        return !(actualIsNil || expectedUsernameIsNil || expectedDisplayNameIsNil ||
                 expectedNumberOfFollowersIsNil || expectedNumberOfFolloweesIsNil ||
                 expectedNumberOfReelsOwnedIsNil || expectedNumberOfAudienceMembershipsIsNil ||
                 expectedCurrentUserIsFollowingIsNil);
    });
    
    match(^BOOL {
        if (!actualIsUser) {
            return NO;
        }
        actualUser = (RTUser *)actual;
        
        actualUsername = actualUser.username;
        actualDisplayName = actualUser.displayName;
        
        actualNumberOfFollowers = actualUser.numberOfFollowers;
        actualNumberOfFollowees = actualUser.numberOfFollowees;
        
        actualNumberOfReelsOwned = actualUser.numberOfReelsOwned;
        actualNumberOfAudienceMemberships = actualUser.numberOfAudienceMemberships;
        
        actualCurrentUserIsFollowing = actualUser.currentUserIsFollowing;
        
        sameUsername = [actualUsername isEqualToString:expectedUsername];
        sameDisplayName = [actualDisplayName isEqualToString:expectedDisplayName];
        
        sameNumberOfFollowers = [actualNumberOfFollowers isEqualToNumber:expectedNumberOfFollowers];
        sameNumberOfFollowees = [actualNumberOfFollowees isEqualToNumber:expectedNumberOfFollowees];
        
        sameNumberOfReelsOwned = [actualNumberOfReelsOwned isEqualToNumber:expectedNumberOfReelsOwned];
        sameNumberOfAudienceMemberships = [actualNumberOfAudienceMemberships isEqualToNumber:expectedNumberOfAudienceMemberships];
        
        sameCurrentUserIsFollowing = (actualCurrentUserIsFollowing.boolValue == expectedCurrentUserIsFollowing.boolValue);
        
        return (sameUsername && sameDisplayName &&
                sameNumberOfFollowers && sameNumberOfFollowees &&
                sameNumberOfReelsOwned && sameNumberOfAudienceMemberships &&
                sameCurrentUserIsFollowing);
    });
    
    failureMessageForTo(^NSString * {
        if (actualIsNil) {
            return actualValueIsNil();
        }
        if (expectedUsernameIsNil) {
            return expectedValueIsNil(@"username");
        }
        if (expectedDisplayNameIsNil) {
            return expectedValueIsNil(@"display name");
        }
        if (expectedNumberOfFollowersIsNil) {
            return expectedValueIsNil(@"number of followers");
        }
        if (expectedNumberOfFolloweesIsNil) {
            return expectedValueIsNil(@"number of followees");
        }
        if (expectedNumberOfReelsOwnedIsNil) {
            return expectedValueIsNil(@"number of reels owned");
        }
        if (expectedCurrentUserIsFollowingIsNil) {
            return expectedValueIsNil(@"current user is following");
        }
        if (!actualIsUser) {
            return actualIsNotClass([actual class], [RTUser class]);
        }
        if (!sameUsername) {
            return actualIsNotExpected(@"username", actualUsername, expectedUsername);
        }
        if (!sameDisplayName) {
            return actualIsNotExpected(@"display name", actualDisplayName, expectedDisplayName);
        }
        if (!sameNumberOfFollowers) {
            return actualIsNotExpected(@"number of followers", actualNumberOfFollowers, expectedNumberOfFollowers);
        }
        if (!sameNumberOfFollowees) {
             return actualIsNotExpected(@"number of followees", actualNumberOfFollowees, expectedNumberOfFollowees);
        }
        if (!sameNumberOfReelsOwned) {
            return actualIsNotExpected(@"number of reels owned", actualNumberOfReelsOwned, expectedNumberOfReelsOwned);
        }
        if (!sameNumberOfAudienceMemberships) {
            actualIsNotExpected(@"number of audience memberships",
                                actualNumberOfAudienceMemberships, expectedNumberOfAudienceMemberships);
        }
        return actualIsNotExpected(@"current user is following", actualCurrentUserIsFollowing, expectedCurrentUserIsFollowing);
    });
    
    failureMessageForNotTo(^NSString * {
        if (actualIsNil) {
            return actualValueIsNil();
        }
        if (expectedUsernameIsNil) {
            return expectedValueIsNil(@"username");
        }
        if (expectedDisplayNameIsNil) {
            return expectedValueIsNil(@"display name");
        }
        if (expectedNumberOfFollowersIsNil) {
            return expectedValueIsNil(@"number of followers");
        }
        if (expectedNumberOfFolloweesIsNil) {
            return expectedValueIsNil(@"number of followees");
        }
        if (expectedCurrentUserIsFollowingIsNil) {
            return expectedValueIsNil(@"current user is following");
        }
        if (actualIsUser) {
            return actualIsClass([actual class], [RTUser class]);
        }
        if (sameUsername) {
            return actualIsExpected(@"username", actualUsername, expectedUsername);
        }
        if (sameDisplayName) {
            return actualIsExpected(@"display name", actualDisplayName, expectedDisplayName);
        }
        if (sameNumberOfFollowers) {
            return actualIsExpected(@"number of followers", actualNumberOfFollowers, expectedNumberOfFollowers);
        }
        if (!sameNumberOfFollowees) {
            return actualIsExpected(@"number of followees", actualNumberOfFollowees, expectedNumberOfFollowees);
        }
        if (!sameNumberOfReelsOwned) {
            return actualIsExpected(@"number of reels owned", actualNumberOfReelsOwned, expectedNumberOfReelsOwned);
        }
        if (!sameCurrentUserIsFollowing) {
            actualIsExpected(@"number of audience memberships", actualNumberOfAudienceMemberships, expectedNumberOfAudienceMemberships);
        }
        return actualIsExpected(@"current user is following", actualCurrentUserIsFollowing, expectedCurrentUserIsFollowing);
    });
}
EXPMatcherImplementationEnd