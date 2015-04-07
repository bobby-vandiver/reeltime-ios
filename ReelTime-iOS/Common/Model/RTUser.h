#import <Foundation/Foundation.h>

@interface RTUser : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *displayName;

@property (nonatomic, copy) NSNumber *numberOfFollowers;
@property (nonatomic, copy) NSNumber *numberOfFollowees;

@property (nonatomic, copy) NSNumber *numberOfReelsOwned;
@property (nonatomic, copy) NSNumber *numberOfAudienceMemberships;

- (instancetype)initWithUsername:(NSString *)username
                     displayName:(NSString *)displayName
               numberOfFollowers:(NSNumber *)numberOfFollowers
               numberOfFollowees:(NSNumber *)numberOfFollowees
              numberOfReelsOwned:(NSNumber *)numberOfReelsOwned
     numberOfAudienceMemberships:(NSNumber *)numberOfAudienceMemberships;

- (BOOL)isEqualToUser:(RTUser *)user;

@end
