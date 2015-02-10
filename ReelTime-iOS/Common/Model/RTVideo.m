#import "RTVideo.h"

@implementation RTVideo

- (instancetype)initWithVideoId:(NSNumber *)videoId
                          title:(NSString *)title {
    self = [super init];
    if (self) {
        self.videoId = videoId;
        self.title = title;
    }
    return self;
}

- (BOOL)isEqualToVideo:(RTVideo *)video {
    BOOL sameVideoId = [self.videoId isEqual:video.videoId];
    BOOL sameTitle = [self.title isEqual:video.title];
    
    return sameVideoId && sameTitle;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[RTVideo class]]) {
        return NO;
    }
    
    return [self isEqualToVideo:(RTVideo *)object];
}

- (NSUInteger)hash {
    NSUInteger videoIdHash = [self.videoId hash] << 20;
    NSUInteger titleHash = [self.title hash] << 5;
    
    return videoIdHash ^ titleHash;
}

@end
