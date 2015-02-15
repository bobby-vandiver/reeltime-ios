#import <Foundation/Foundation.h>

@class RTNewsfeedViewController;

@interface RTNewsfeedWireframe : NSObject

- (instancetype)initWithViewController:(RTNewsfeedViewController *)viewController;

- (void)presentUserForUsername:(NSString *)username;

- (void)presentReelForReelId:(NSNumber *)reelId;

- (void)presentVideoForVideoId:(NSNumber *)videoId;

@end
