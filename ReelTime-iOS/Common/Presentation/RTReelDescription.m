#import "RTReelDescription.h"

@interface RTReelDescription ()

@property (readwrite, copy) NSString *name;
@property (readwrite, copy) NSNumber *reelId;

@property (readwrite, copy) NSNumber *audienceSize;
@property (readwrite, copy) NSNumber *numberOfVideos;

@property (readwrite, copy) NSNumber *currentUserIsAnAudienceMember;
@property (readwrite, copy) NSString *ownerUsername;

@end

@implementation RTReelDescription

+ (RTReelDescription *)reelDescriptionWithName:(NSString *)name
                                     forReelId:(NSNumber *)reelId
                                  audienceSize:(NSNumber *)audienceSize
                                numberOfVideos:(NSNumber *)numberOfVideos
                 currentUserIsAnAudienceMember:(NSNumber *)currentUserIsAnAudienceMember
                                 ownerUsername:(NSString *)ownerUsername {

    return [[RTReelDescription alloc] initWithName:name
                                         forReelId:reelId
                                      audienceSize:audienceSize
                                    numberOfVideos:numberOfVideos
                     currentUserIsAnAudienceMember:currentUserIsAnAudienceMember
                                     ownerUsername:ownerUsername];
}

- (instancetype)initWithName:(NSString *)name
                   forReelId:(NSNumber *)reelId
                audienceSize:(NSNumber *)audienceSize
              numberOfVideos:(NSNumber *)numberOfVideos
currentUserIsAnAudienceMember:(NSNumber *)currentUserIsAnAudienceMember
               ownerUsername:(NSString *)ownerUsername {
    self = [super init];
    if (self) {
        self.name = name;
        self.reelId = reelId;
        self.audienceSize = audienceSize;
        self.numberOfVideos = numberOfVideos;
        self.currentUserIsAnAudienceMember = currentUserIsAnAudienceMember;
        self.ownerUsername = ownerUsername;
    }
    return self;
}

- (void)currentUserJoinedAudience {
    self.currentUserIsAnAudienceMember = @(YES);
    self.audienceSize = [NSNumber numberWithInteger:[self.audienceSize integerValue] + 1];
}

- (void)currentUserLeftAudience {
    self.currentUserIsAnAudienceMember = @(NO);
    self.audienceSize = [NSNumber numberWithInteger:[self.audienceSize integerValue] - 1];
}

- (BOOL)isEqualToReelDescription:(RTReelDescription *)reelDescription {
    return [self.reelId isEqual:reelDescription.reelId];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[RTReelDescription class]]) {
        return NO;
    }
    
    return [self isEqualToReelDescription:(RTReelDescription *)object];
}

- (NSUInteger)hash {
    return [self.reelId hash];
}

@end
