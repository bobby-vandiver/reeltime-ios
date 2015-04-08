#import "RTUserDescription.h"

@interface RTUserDescription ()

@property (readwrite, copy) NSString *username;
@property (readwrite, copy) NSString *displayName;

@property (readwrite, copy) NSNumber *numberOfFollowers;
@property (readwrite, copy) NSNumber *numberOfFollowees;

@property (readwrite, copy) NSNumber *numberOfReelsOwned;
@property (readwrite, copy) NSNumber *numberOfAudienceMemberships;

@end

@implementation RTUserDescription

+ (RTUserDescription *)userDescriptionWithForUsername:(NSString *)username
                                      withDisplayName:(NSString *)displayName
                                    numberOfFollowers:(NSNumber *)numberOfFollowers
                                    numberOfFollowees:(NSNumber *)numberOfFollowees
                                   numberOfReelsOwned:(NSNumber *)numberOfReelsOwned
                          numberOfAudienceMemberships:(NSNumber *)numberOfAudienceMemberships {

    return [[RTUserDescription alloc] initForUsername:username
                                      withDisplayName:displayName
                                    numberOfFollowers:numberOfFollowers
                                    numberOfFollowees:numberOfFollowees
                                   numberOfReelsOwned:numberOfReelsOwned
                          numberOfAudienceMemberships:numberOfAudienceMemberships];
}

- (instancetype)initForUsername:(NSString *)username
                withDisplayName:(NSString *)displayName
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

@end
