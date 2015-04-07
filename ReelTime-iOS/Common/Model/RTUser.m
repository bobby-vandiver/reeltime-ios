#import "RTUser.h"

@implementation RTUser

- (instancetype)initWithUsername:(NSString *)username
                     displayName:(NSString *)displayName
               numberOfFollowers:(NSNumber *)numberOfFollowers
               numberOfFollowees:(NSNumber *)numberOfFollowees
              numberOfReelsOwned:(NSNumber *)numberOfReelsOwned
     numberOfAudienceMemberships:(NSNumber *)numberOfAudienceMemberships {
    self = [super init];
    if (self) {
        self.username = username;
        self.displayName = displayName;
        self.numberOfFollowers = numberOfFollowers;
        self.numberOfFollowees = numberOfFollowees;
        self.numberOfReelsOwned = numberOfReelsOwned;
        self.numberOfAudienceMemberships = numberOfAudienceMemberships;
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

@end
