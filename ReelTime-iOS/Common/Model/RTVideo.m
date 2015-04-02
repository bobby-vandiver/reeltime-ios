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
    BOOL sameVideoId = [self.videoId isEqual:video.videoId];
    BOOL sameTitle = [self.title isEqual:video.title];
    BOOL sameThumbnail = [self.thumbnail isEqual:video.thumbnail];
    
    return sameVideoId && sameTitle && sameThumbnail;
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
    NSUInteger titleHash = [self.title hash] << 10;
    NSUInteger thumbnailHash = [self.thumbnail hash];
    
    return videoIdHash ^ titleHash ^ thumbnailHash;
}

@end
