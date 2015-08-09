#import <Foundation/Foundation.h>

@class RTPlayVideoViewController;

@protocol RTPlayVideoViewControllerFactory <NSObject>

- (RTPlayVideoViewController *)playVideoViewControllerForVideoId:(NSNumber *)videoId;

@end
