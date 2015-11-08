#import "RTUser.h"
#import "RTStringUtils.h"

@implementation RTUser

- (instancetype)initWithUsername:(NSString *)username
                     displayName:(NSString *)displayName
               numberOfFollowers:(NSNumber *)numberOfFollowers
               numberOfFollowees:(NSNumber *)numberOfFollowees
              numberOfReelsOwned:(NSNumber *)numberOfReelsOwned
     numberOfAudienceMemberships:(NSNumber *)numberOfAudienceMemberships
          currentUserIsFollowing:(NSNumber *)currentUserIsFollowing {
    self = [super init];
    if (self) {
        self.username = username;
        self.displayName = displayName;
        self.numberOfFollowers = numberOfFollowers;
        self.numberOfFollowees = numberOfFollowees;
        self.numberOfReelsOwned = numberOfReelsOwned;
        self.numberOfAudienceMemberships = numberOfAudienceMemberships;
        self.currentUserIsFollowing = currentUserIsFollowing;
    }
    return self;
}

- (BOOL)isEqualToUser:(RTUser *)user {
    return [self.username isEqual:user.username];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[RTUser class]]) {
        return NO;
    }
    
    return [self isEqualToUser:(RTUser *)object];
}

- (NSUInteger)hash {
    return [self.username hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:
            @"{"
            @"username: %@, "
            @"displayName: %@, "
            @"numberOfFollowers: %@, "
            @"numberOfFollowees: %@, "
            @"numberOfReelsOwned: %@, "
            @"numberOfAudienceMemberships: %@, "
            @"currentUserIsFollowing: %@"
            @"}",
            self.username,
            self.displayName,
            self.numberOfFollowers,
            self.numberOfFollowees,
            self.numberOfReelsOwned,
            self.numberOfAudienceMemberships,
            stringForBool(self.currentUserIsFollowing)];
}

@end
