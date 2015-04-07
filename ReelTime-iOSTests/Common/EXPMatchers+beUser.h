#import <Expecta/Expecta.h>

EXPMatcherInterface(beUser, (NSString *expectedUsername, NSString *expectedDisplayName,
                             NSNumber *expectedNumberOfFollowers, NSNumber *expectedNumberOfFollowees,
                             NSNumber *expectedNumberOfReelsOwned, NSNumber *expectedNumberOfAudienceMemberships));

#define beUser beUser