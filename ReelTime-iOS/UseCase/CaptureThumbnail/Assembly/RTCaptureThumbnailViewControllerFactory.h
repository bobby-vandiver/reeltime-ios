#import <Foundation/Foundation.h>

@class RTCaptureThumbnailViewController;

@protocol RTCaptureThumbnailViewControllerFactory <NSObject>

- (RTCaptureThumbnailViewController *)captureThumbnailViewControllerForVideo:(NSURL *)videoURL;

@end
