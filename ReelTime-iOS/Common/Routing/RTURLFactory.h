#import <Foundation/Foundation.h>

@class RTUser;
@class RTReel;
@class RTVideo;

@interface RTURLFactory : NSObject

+ (NSURL *)URLForUser:(RTUser *)user;

+ (NSURL *)URLForReel:(RTReel *)reel;

+ (NSURL *)URLForVideo:(RTVideo *)video;

@end
