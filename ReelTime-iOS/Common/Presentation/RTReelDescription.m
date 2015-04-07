#import "RTReelDescription.h"

@interface RTReelDescription ()

@property (readwrite, copy) NSString *text;
@property (readwrite, copy) NSNumber *reelId;
@property (readwrite, copy) NSString *ownerUsername;

@end

@implementation RTReelDescription

+ (RTReelDescription *)reelDescriptionWithText:(NSString *)text
                                     forReelId:(NSNumber *)reelId
                                 ownerUsername:(NSString *)ownerUsername {
    return [[RTReelDescription alloc] initWithText:text forReelId:reelId ownerUsername:ownerUsername];
}

- (instancetype)initWithText:(NSString *)text
                   forReelId:(NSNumber *)reelId
               ownerUsername:(NSString *)ownerUsername {
    self = [super init];
    if (self) {
        self.text = text;
        self.reelId = reelId;
        self.ownerUsername = ownerUsername;
    }
    return self;
}

@end
