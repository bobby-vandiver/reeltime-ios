#import "EXPMatchers+beUser.h"
#import "EXPMatchers+ErrorMessages.h"

#import "RTUser.h"

EXPMatcherImplementationBegin(beUser, (NSString *expectedUsername, NSString *expectedDisplayName,
                                       NSNumber *expectedNumberOfFollowers, NSNumber *expectedNumberOfFollowees)) {
    BOOL actualIsNil = (actual == nil);
    BOOL actualIsUser = [actual isKindOfClass:[RTUser class]];
    
    BOOL expectedUsernameIsNil = (expectedUsername == nil);
    BOOL expectedDisplayNameIsNil = (expectedDisplayName == nil);
    
    BOOL expectedNumberOfFollowersIsNil = (expectedNumberOfFollowers == nil);
    BOOL expectedNumberOfFolloweesIsNil = (expectedNumberOfFollowees == nil);
    
    __block RTUser *actualUser;
    
    __block NSString *actualUsername;
    __block NSString *actualDisplayName;
    
    __block NSNumber *actualNumberOfFollowers;
    __block NSNumber *actualNumberOfFollowees;
    
    __block BOOL sameUsername;
    __block BOOL sameDisplayName;

    __block BOOL sameNumberOfFollowers;
    __block BOOL sameNumberOfFollowees;

    prerequisite(^BOOL {
        return !(actualIsNil || expectedUsernameIsNil || expectedDisplayNameIsNil ||
                 expectedNumberOfFollowersIsNil || expectedNumberOfFolloweesIsNil);
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
        
        sameUsername = [actualUsername isEqualToString:expectedUsername];
        sameDisplayName = [actualDisplayName isEqualToString:expectedDisplayName];
        
        sameNumberOfFollowers = [actualNumberOfFollowers isEqualToNumber:expectedNumberOfFollowers];
        sameNumberOfFollowees = [actualNumberOfFollowees isEqualToNumber:expectedNumberOfFollowees];
        
        return (sameUsername && sameDisplayName && sameNumberOfFollowers && sameNumberOfFollowees);
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
        return actualIsNotExpected(@"number of followees", actualNumberOfFollowees, expectedNumberOfFollowees);
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
        return actualIsExpected(@"number of followees", actualNumberOfFollowees, expectedNumberOfFollowees);
    });
}
EXPMatcherImplementationEnd