#import <Foundation/Foundation.h>

@interface RTUserDescription : NSObject

@property (readonly, copy) NSString *displayName;
@property (readonly, copy) NSString *username;

@property (readonly, copy) NSNumber *numberOfFollowers;
@property (readonly, copy) NSNumber *numberOfFollowees;

@property (readonly, copy) NSNumber *numberOfReelsOwned;
@property (readonly, copy) NSNumber *numberOfAudienceMemberships;

+ (RTUserDescription *)userDescriptionWithForUsername:(NSString *)username
                                      withDisplayName:(NSString *)displayName
                                    numberOfFollowers:(NSNumber *)numberOfFollowers
                                    numberOfFollowees:(NSNumber *)numberOfFollowees
                                   numberOfReelsOwned:(NSNumber *)numberOfReelsOwned
                          numberOfAudienceMemberships:(NSNumber *)numberOfAudienceMemberships;

@end
