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

@end
