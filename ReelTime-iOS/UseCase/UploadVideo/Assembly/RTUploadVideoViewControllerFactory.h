#import <Foundation/Foundation.h>

@class RTUploadVideoViewController;

@protocol RTUploadVideoViewControllerFactory <NSObject>

- (RTUploadVideoViewController *)uploadVideoViewControllerForVideo:(NSURL *)videoUrl
                                                         thumbnail:(NSURL *)thumbnailUrl;

@end
