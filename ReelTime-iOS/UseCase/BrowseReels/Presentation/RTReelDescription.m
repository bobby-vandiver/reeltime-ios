#import "RTReelDescription.h"

@interface RTReelDescription ()

@property (readwrite, copy) NSString *text;
@property (readwrite, copy) NSNumber *reelId;

@end

@implementation RTReelDescription

+ (RTReelDescription *)reelDescriptionWithText:(NSString *)text
                                     forReelId:(NSNumber *)reelId {
    return [[RTReelDescription alloc] initWithText:text forReelId:reelId];
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
