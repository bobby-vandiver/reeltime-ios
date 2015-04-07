#import "RTReelDescription.h"

@interface RTReelDescription ()

@property (readwrite, copy) NSString *name;
@property (readwrite, copy) NSNumber *reelId;
@property (readwrite, copy) NSString *ownerUsername;

@end

@implementation RTReelDescription

+ (RTReelDescription *)reelDescriptionWithName:(NSString *)name
                                     forReelId:(NSNumber *)reelId
                                 ownerUsername:(NSString *)ownerUsername {
    return [[RTReelDescription alloc] initWithName:name forReelId:reelId ownerUsername:ownerUsername];
}

- (instancetype)initWithName:(NSString *)name
                   forReelId:(NSNumber *)reelId
               ownerUsername:(NSString *)ownerUsername {
    self = [super init];
    if (self) {
        self.name = name;
        self.reelId = reelId;
        self.ownerUsername = ownerUsername;
    }
    return self;
}

@end
