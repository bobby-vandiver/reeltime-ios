#import "RTApplicationAwareWireframe.h"

@class RTRecordVideoViewController;
@class RTCaptureThumbnailWireframe;

@interface RTRecordVideoWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTRecordVideoViewController *)viewController
             captureThumbnailWireframe:(RTCaptureThumbnailWireframe *)captureThumbnailWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentVideoCameraInterface;

- (void)presentCaptureThumbnailInterfaceForVideo:(NSURL *)videoURL;

@end
