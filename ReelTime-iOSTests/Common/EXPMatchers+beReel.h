#import <Expecta/Expecta.h>

EXPMatcherInterface(beReel, (NSNumber *expectedReelId, NSString *expectedName,
                             NSNumber *expectedAudienceSize, NSNumber *expectedNumberOfVideos));

#define beReel beReel