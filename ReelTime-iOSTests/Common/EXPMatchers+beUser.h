#import <Expecta/Expecta.h>

EXPMatcherInterface(beUser, (NSString *expectedUsername, NSString *expectedDisplayName,
                             NSNumber *expectedNumberOfFollowers, NSNumber *expectedNumberOfFollowees));

#define beUser beUser