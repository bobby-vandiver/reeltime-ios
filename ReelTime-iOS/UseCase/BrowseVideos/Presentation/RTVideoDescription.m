#import "RTVideoDescription.h"

@interface RTVideoDescription ()

@property (readwrite, copy) NSString *text;
@property (readwrite, copy) NSNumber *videoId;
@property (readwrite, copy) RTThumbnail *thumbnail;

@end

@implementation RTVideoDescription

+ (RTVideoDescription *)videoDescriptionWithText:(NSString *)text
                                         videoId:(NSNumber *)videoId
                                       thumbnail:(RTThumbnail *)thumbnail {
    return [[RTVideoDescription alloc] initWithText:text videoId:videoId thumbnail:thumbnail];
}

- (instancetype)initWithText:(NSString *)text
                     videoId:(NSNumber *)videoId
                   thumbnail:(RTThumbnail *)thumbnail {
    self = [super init];
    if (self) {
        self.text = text;
        self.videoId = videoId;
        self.thumbnail = thumbnail;
    }
    return self;
}

@end
