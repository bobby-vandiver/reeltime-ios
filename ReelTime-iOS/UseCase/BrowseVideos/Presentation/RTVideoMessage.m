#import "RTVideoMessage.h"

@interface RTVideoMessage ()

@property (readwrite, copy) NSString *text;
@property (readwrite, copy) NSNumber *videoId;

@end

@implementation RTVideoMessage

+ (RTVideoMessage *)videoMessageWithText:(NSString *)text
                                 videoId:(NSNumber *)videoId {
    return [[RTVideoMessage alloc] initWithText:text videoId:videoId];
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
