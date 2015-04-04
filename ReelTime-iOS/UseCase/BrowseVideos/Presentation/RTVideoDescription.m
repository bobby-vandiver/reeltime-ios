#import "RTVideoDescription.h"

@interface RTVideoDescription ()

@property (readwrite, copy) NSString *text;
@property (readwrite, copy) NSNumber *videoId;
@property (readwrite, copy) NSData *thumbnailData;

@end

@implementation RTVideoDescription

+ (RTVideoDescription *)videoDescriptionWithText:(NSString *)text
                                         videoId:(NSNumber *)videoId
                                   thumbnailData:(NSData *)thumbnailData {
    return [[RTVideoDescription alloc] initWithText:text videoId:videoId thumbnailData:thumbnailData];
}

- (instancetype)initWithText:(NSString *)text
                     videoId:(NSNumber *)videoId
               thumbnailData:(NSData *)thumbnailData {
    self = [super init];
    if (self) {
        self.text = text;
        self.videoId = videoId;
        self.thumbnailData = thumbnailData;
    }
    return self;
}

@end
