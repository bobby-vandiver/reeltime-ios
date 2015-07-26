#import <Foundation/Foundation.h>
#import "RTBrowseUsersDataManagerDelegate.h"

@interface RTBrowseUserFollowersDataManagerDelegate : NSObject <RTBrowseUsersDataManagerDelegate>

- (instancetype)initWithUsername:(NSString *)username;

@end
