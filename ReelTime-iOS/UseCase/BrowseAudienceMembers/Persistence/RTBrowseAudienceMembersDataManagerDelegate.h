#import <Foundation/Foundation.h>
#import "RTBrowseUsersDataManagerDelegate.h"

@interface RTBrowseAudienceMembersDataManagerDelegate : NSObject <RTBrowseUsersDataManagerDelegate>

- (instancetype)initWithReelId:(NSNumber *)reelId;

@end
