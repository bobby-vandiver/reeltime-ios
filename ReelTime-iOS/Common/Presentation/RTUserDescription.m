#import "RTUserDescription.h"

@interface RTUserDescription ()

@property (readwrite, copy) NSString *username;
@property (readwrite, copy) NSString *displayName;

@property (readwrite, copy) NSNumber *numberOfFollowers;
@property (readwrite, copy) NSNumber *numberOfFollowees;

@property (readwrite, copy) NSNumber *numberOfReelsOwned;
@property (readwrite, copy) NSNumber *numberOfAudienceMemberships;

@property (readwrite, copy) NSNumber *currentUserIsFollowing;

@end

@implementation RTUserDescription

+ (RTUserDescription *)userDescriptionWithForUsername:(NSString *)username
                                      withDisplayName:(NSString *)displayName
                                    numberOfFollowers:(NSNumber *)numberOfFollowers
                                    numberOfFollowees:(NSNumber *)numberOfFollowees
                                   numberOfReelsOwned:(NSNumber *)numberOfReelsOwned
                          numberOfAudienceMemberships:(NSNumber *)numberOfAudienceMemberships
                               currentUserIsFollowing:(NSNumber *)currentUserIsFollowing {

    return [[RTUserDescription alloc] initForUsername:username
                                      withDisplayName:displayName
                                    numberOfFollowers:numberOfFollowers
                                    numberOfFollowees:numberOfFollowees
                                   numberOfReelsOwned:numberOfReelsOwned
                          numberOfAudienceMemberships:numberOfAudienceMemberships
                               currentUserIsFollowing:currentUserIsFollowing];
}

- (instancetype)initForUsername:(NSString *)username
                withDisplayName:(NSString *)displayName
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

- (BOOL)isEqualToUserDescription:(RTUserDescription *)userDescription {
    return [self.username isEqual:userDescription.username];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[RTUserDescription class]]) {
        return NO;
    }
    
    return [self isEqualToUserDescription:(RTUserDescription *)object];
}

- (NSUInteger)hash {
    return [self.username hash];
}

@end
