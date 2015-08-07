#import <Foundation/Foundation.h>

@interface RTUserDescription : NSObject

@property (readonly, copy) NSString *displayName;
@property (readonly, copy) NSString *username;

@property (readonly, copy) NSNumber *numberOfFollowers;
@property (readonly, copy) NSNumber *numberOfFollowees;

@property (readonly, copy) NSNumber *numberOfReelsOwned;
@property (readonly, copy) NSNumber *numberOfAudienceMemberships;

@property (readonly, copy) NSNumber *currentUserIsFollowing;

+ (RTUserDescription *)userDescriptionWithForUsername:(NSString *)username
                                      withDisplayName:(NSString *)displayName
                                    numberOfFollowers:(NSNumber *)numberOfFollowers
                                    numberOfFollowees:(NSNumber *)numberOfFollowees
                                   numberOfReelsOwned:(NSNumber *)numberOfReelsOwned
                          numberOfAudienceMemberships:(NSNumber *)numberOfAudienceMemberships
                               currentUserIsFollowing:(NSNumber *)currentUserIsFollowing;

- (BOOL)isEqualToUserDescription:(RTUserDescription *)userDescription;

@end
