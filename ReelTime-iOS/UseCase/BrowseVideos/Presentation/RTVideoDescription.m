#import "RTVideoDescription.h"

@interface RTVideoDescription ()

@property (readwrite, copy) NSString *text;
@property (readwrite, copy) NSNumber *videoId;

@end

@implementation RTVideoDescription

+ (RTVideoDescription *)videoDescriptionWithText:(NSString *)text
                                         videoId:(NSNumber *)videoId {
    return [[RTVideoDescription alloc] initWithText:text videoId:videoId];
}

- (instancetype)initWithText:(NSString *)text
                     videoId:(NSNumber *)videoId {
    self = [super init];
    if (self) {
        self.text = text;
        self.videoId = videoId;
    }
    return self;
}

@end
