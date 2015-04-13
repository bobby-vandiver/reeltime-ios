#import <Foundation/Foundation.h>
#import "RTBrowseVideosDataManagerDelegate.h"

@interface RTBrowseReelVideosDataManagerDelegate : NSObject <RTBrowseVideosDataManagerDelegate>

- (instancetype)initWithReelId:(NSNumber *)reelId;

@end
