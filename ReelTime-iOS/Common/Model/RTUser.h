#import <Foundation/Foundation.h>

@interface RTUser : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *displayName;

@property (nonatomic, copy) NSNumber *numberOfFollowers;
@property (nonatomic, copy) NSNumber *numberOfFollowees;

@end
