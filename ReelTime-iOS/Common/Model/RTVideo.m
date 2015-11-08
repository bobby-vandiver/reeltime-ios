#import "RTVideo.h"
#import "RTThumbnail.h"

@implementation RTVideo

- (instancetype)initWithVideoId:(NSNumber *)videoId
                          title:(NSString *)title
                      thumbnail:(RTThumbnail *)thumbnail {
    self = [super init];
    if (self) {
        self.videoId = videoId;
        self.title = title;
        self.thumbnail = thumbnail;
    }
    return self;
}

- (BOOL)isEqualToVideo:(RTVideo *)video {
    return [self.videoId isEqual:video.videoId];
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
    return [self.videoId hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{videoId: %@, title: %@, thumbnail: %lu}",
            self.videoId, self.title, self.thumbnail.hash];
}

@end
