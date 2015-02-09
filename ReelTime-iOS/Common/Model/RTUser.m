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

@end
