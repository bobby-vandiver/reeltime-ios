#import <Foundation/Foundation.h>

@interface RTUser : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *displayName;

@property (nonatomic, copy) NSNumber *numberOfFollowers;
@property (nonatomic, copy) NSNumber *numberOfFollowees;

- (instancetype)initWithUsername:(NSString *)username
                     displayName:(NSString *)displayName
               numberOfFollowers:(NSNumber *)numberOfFollowers
               numberOfFollowees:(NSNumber *)numberOfFollowees;

- (BOOL)isEqualToUser:(RTUser *)user;

@end
