#import "RTActivity.h"

@implementation RTActivity

+ (RTActivity *)createReelActivityWithUser:(RTUser *)user
                                      reel:(RTReel *)reel {
    return [[RTActivity alloc] initWithType:RTActivityTypeCreateReel
                                       user:user
                                       reel:reel
                                      video:nil];
}

+ (RTActivity *)joinReelActivityWithUser:(RTUser *)user
                                    reel:(RTReel *)reel {
    return [[RTActivity alloc] initWithType:RTActivityTypeJoinReelAudience
                                       user:user
                                       reel:reel
                                      video:nil];
}

+ (RTActivity *)addVideoToReelActivityWithUser:(RTUser *)user
                                          reel:(RTReel *)reel
                                         video:(RTVideo *)video {
    return [[RTActivity alloc] initWithType:RTActivityTypeAddVideoToReel
                                       user:user
                                       reel:reel
                                      video:video];
}

- (instancetype)initWithType:(RTActivityType)type
                        user:(RTUser *)user
                        reel:(RTReel *)reel
                       video:(RTVideo *)video {
    self = [super init];
    if (self) {
        self.type = [NSNumber numberWithInteger:type];
        self.user = user;
        self.reel = reel;
        self.video = video;
    }
    return self;
}

@end
