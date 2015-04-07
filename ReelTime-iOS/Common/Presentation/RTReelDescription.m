#import "RTReelDescription.h"

@interface RTReelDescription ()

@property (readwrite, copy) NSString *name;
@property (readwrite, copy) NSNumber *reelId;

@property (readwrite, copy) NSNumber *audienceSize;
@property (readwrite, copy) NSNumber *numberOfVideos;

@property (readwrite, copy) NSString *ownerUsername;

@end

@implementation RTReelDescription

+ (RTReelDescription *)reelDescriptionWithName:(NSString *)name
                                     forReelId:(NSNumber *)reelId
                                  audienceSize:(NSNumber *)audienceSize
                                numberOfVideos:(NSNumber *)numberOfVideos
                                 ownerUsername:(NSString *)ownerUsername {

    return [[RTReelDescription alloc] initWithName:name
                                         forReelId:reelId
                                      audienceSize:audienceSize
                                    numberOfVideos:numberOfVideos
                                     ownerUsername:ownerUsername];
}

- (instancetype)initWithName:(NSString *)name
                   forReelId:(NSNumber *)reelId
                audienceSize:(NSNumber *)audienceSize
              numberOfVideos:(NSNumber *)numberOfVideos
               ownerUsername:(NSString *)ownerUsername {
    self = [super init];
    if (self) {
        self.name = name;
        self.reelId = reelId;
        self.audienceSize = audienceSize;
        self.numberOfVideos = numberOfVideos;
        self.ownerUsername = ownerUsername;
    }
    return self;
}

@end
