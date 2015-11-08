#import "RTReel.h"
#import "RTUser.h"
#import "RTStringUtils.h"

@implementation RTReel

- (instancetype)initWithReelId:(NSNumber *)reelId
                          name:(NSString *)name
                  audienceSize:(NSNumber *)audienceSize
                numberOfVideos:(NSNumber *)numberOfVideos
 currentUserIsAnAudienceMember:(NSNumber *)currentUserIsAnAudienceMember
                         owner:(RTUser *)owner {
    self = [super init];
    if (self) {
        self.reelId = reelId;
        self.name = name;
        self.audienceSize = audienceSize;
        self.numberOfVideos = numberOfVideos;
        self.currentUserIsAnAudienceMember = currentUserIsAnAudienceMember;
        self.owner = owner;
    }
    return self;
}

- (BOOL)isEqualToReel:(RTReel *)reel {
    return [self.reelId isEqual:reel.reelId];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[RTReel class]]) {
        return NO;
    }
    
    return [self isEqualToReel:(RTReel *)object];
}

- (NSUInteger)hash {
    return [self.reelId hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{reelId: %@, name: %@, audienceSize: %@, numberOfVideos: %@, currentUserIsAnAudienceMember: %@, owner: %@}", self.reelId, self.name, self.audienceSize, self.numberOfVideos, stringForBool(self.currentUserIsAnAudienceMember), [self.owner description]];
}

@end
