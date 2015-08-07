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

- (BOOL)isEqualToVideoDescription:(RTVideoDescription *)videoDescription {
    return [self.videoId isEqual:videoDescription.videoId];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[RTVideoDescription class]]) {
        return NO;
    }
    
    return [self isEqualToVideoDescription:(RTVideoDescription *)object];
}

- (NSUInteger)hash {
    return [self.videoId hash];
}

@end
