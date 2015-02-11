#import "RTReel.h"

@implementation RTReel

- (instancetype)initWithReelId:(NSNumber *)reelId
                          name:(NSString *)name
                  audienceSize:(NSNumber *)audienceSize
                numberOfVideos:(NSNumber *)numberOfVideos {
    self = [super init];
    if (self) {
        self.reelId = reelId;
        self.name = name;
        self.audienceSize = audienceSize;
        self.numberOfVideos = numberOfVideos;
    }
    return self;
}

- (BOOL)isEqualToReel:(RTReel *)reel {
    BOOL sameReelId = [self.reelId isEqual:reel.reelId];
    BOOL sameName = [self.name isEqual:reel.name];
    
    BOOL sameAudienceSize = [self.audienceSize isEqual:reel.audienceSize];
    BOOL sameNumberOfVideos = [self.numberOfVideos isEqual:reel.numberOfVideos];
    
    return sameReelId && sameName && sameAudienceSize && sameNumberOfVideos;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[RTReel class]]) {
        return NO;
    }
    
    return [self isEqualToReel:(RTReel *)object];
}

- (NSUInteger)hash {
    NSUInteger reelIdHash = [self.reelId hash] << 16;
    NSUInteger nameHash = [self.name hash] << 12;

    NSUInteger audienceSizeHash = [self.audienceSize hash] << 8;
    NSUInteger numberOfVideosHash = [self.numberOfVideos hash] << 4;
    
    return reelIdHash ^ nameHash ^ audienceSizeHash ^ numberOfVideosHash;
}

@end
