#import <Expecta/Expecta.h>

EXPMatcherInterface(beUser, (NSString *expectedUsername, NSString *expectedDisplayName,
                             NSNumber *expectedNumberOfFollowers, NSNumber *expectedNumberOfFollowees,
                             NSNumber *expectedNumberOfReelsOwned, NSNumber *expectedNumberOfAudienceMemberships,
                             NSNumber *expectedCurrentUserIsFollowing));

#define beUser beUser