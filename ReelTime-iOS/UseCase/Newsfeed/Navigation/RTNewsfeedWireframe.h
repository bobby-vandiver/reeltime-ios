#import <Foundation/Foundation.h>

@interface RTNewsfeedWireframe : NSObject

- (void)presentUserForUsername:(NSString *)username;

- (void)presentReelForReelId:(NSNumber *)reelId;

- (void)presentVideoForVideoId:(NSNumber *)videoId;

@end
