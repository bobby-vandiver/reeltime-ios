#import "RTUser.h"

@implementation RTUser

- (instancetype)initWithUsername:(NSString *)username
                     displayName:(NSString *)displayName
               numberOfFollowers:(NSNumber *)numberOfFollowers
               numberOfFollowees:(NSNumber *)numberOfFollowees {
    self = [super init];
    if (self) {
        self.username = username;
        self.displayName = displayName;
        self.numberOfFollowers = numberOfFollowers;
        self.numberOfFollowees = numberOfFollowees;
    }
    return self;
}

- (BOOL)isEqualToUser:(RTUser *)user {
    BOOL sameUsername = [self.username isEqual:user.username];
    BOOL sameDisplayName = [self.displayName isEqual:user.displayName];
    
    BOOL sameNumberOfFollowers = [self.numberOfFollowers isEqual:user.numberOfFollowers];
    BOOL sameNumberOfFollowees = [self.numberOfFollowees isEqual:user.numberOfFollowees];
    
    return sameUsername && sameDisplayName && sameNumberOfFollowers && sameNumberOfFollowees;
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
    NSUInteger usernameHash = [self.username hash] << 24;
    NSUInteger displayNameHash = [self.displayName hash] << 16;
    NSUInteger numberOfFollowersHash = [self.numberOfFollowers hash] << 8;
    NSUInteger numberOfFolloweeshash = [self.numberOfFollowees hash];
    
    return usernameHash ^ displayNameHash ^ numberOfFollowersHash ^ numberOfFolloweeshash;
}

@end
