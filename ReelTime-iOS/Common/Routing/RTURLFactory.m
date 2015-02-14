#import "RTURLFactory.h"

#import "RTUser.h"
#import "RTReel.h"
#import "RTVideo.h"

@implementation RTURLFactory

+ (NSURL *)URLForUser:(RTUser *)user {
    NSString *url = [NSString stringWithFormat:@"reeltime://users/%@", user.username];
    return [NSURL URLWithString:url];
}

+ (NSURL *)URLForReel:(RTReel *)reel {
    NSString *url = [NSString stringWithFormat:@"reeltime://reels/%@", reel.reelId];
    return [NSURL URLWithString:url];
}

+ (NSURL *)URLForVideo:(RTVideo *)video {
    NSString *url = [NSString stringWithFormat:@"reeltime://videos/%@", video.videoId];
    return [NSURL URLWithString:url];
}

@end
