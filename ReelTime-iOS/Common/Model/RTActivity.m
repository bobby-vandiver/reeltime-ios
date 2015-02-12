#import "RTActivity.h"

#import "RTUser.h"
#import "RTReel.h"
#import "RTVideo.h"

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

- (BOOL)isEqualToActivity:(RTActivity *)activity {
    BOOL sameType = [self.type isEqual:activity.type];
    
    BOOL sameUser = [self.user isEqual:activity.user];
    BOOL sameReel = [self.reel isEqual:activity.reel];

    BOOL includeVideo = [self.type isEqual:@(RTActivityTypeAddVideoToReel)];
    BOOL sameVideo = includeVideo ? [self.video isEqual:activity.video] : YES;
    
    return sameType && sameUser && sameReel && sameVideo;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[RTActivity class]]) {
        return NO;
    }
    
    return [self isEqualToActivity:(RTActivity *)object];
}

- (NSUInteger)hash {
    NSUInteger typeHash = [self.type hash] * 31;
    NSUInteger userHash = [self.user hash] * 17;
    NSUInteger reelHash = [self.reel hash] * 13;
    NSUInteger videoHash = [self.video hash] * 11;
    
    return typeHash ^ userHash ^ reelHash ^ videoHash;
}

@end
