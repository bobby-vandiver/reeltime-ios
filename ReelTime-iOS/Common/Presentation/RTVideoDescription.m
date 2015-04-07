#import "RTVideoDescription.h"

@interface RTVideoDescription ()

@property (readwrite, copy) NSString *title;
@property (readwrite, copy) NSNumber *videoId;
@property (readwrite, copy) NSData *thumbnailData;

@end

@implementation RTVideoDescription

+ (RTVideoDescription *)videoDescriptionWithTitle:(NSString *)title
                                          videoId:(NSNumber *)videoId
                                    thumbnailData:(NSData *)thumbnailData {
    return [[RTVideoDescription alloc] initWithTitle:title videoId:videoId thumbnailData:thumbnailData];
}

- (instancetype)initWithTitle:(NSString *)title
                      videoId:(NSNumber *)videoId
                thumbnailData:(NSData *)thumbnailData {
    self = [super init];
    if (self) {
        self.title = title;
        self.videoId = videoId;
        self.thumbnailData = thumbnailData;
    }
    return self;
}

@end
