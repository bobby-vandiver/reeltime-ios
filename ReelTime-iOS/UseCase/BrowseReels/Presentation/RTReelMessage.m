#import "RTReelMessage.h"

@interface RTReelMessage ()

@property (readwrite, copy) NSString *text;
@property (readwrite, copy) NSNumber *reelId;

@end

@implementation RTReelMessage

+ (RTReelMessage *)reelMessageWithText:(NSString *)text
                             forReelId:(NSNumber *)reelId {
    return [[RTReelMessage alloc] initWithText:text forReelId:reelId];
}

- (instancetype)initWithText:(NSString *)text
                   forReelId:(NSNumber *)reelId {
    self = [super init];
    if (self) {
        self.text = text;
        self.reelId = reelId;
    }
    return self;
}

@end
