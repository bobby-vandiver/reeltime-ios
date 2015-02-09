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

@end
