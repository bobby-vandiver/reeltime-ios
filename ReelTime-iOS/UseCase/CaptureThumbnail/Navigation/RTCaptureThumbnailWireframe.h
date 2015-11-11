#import "RTApplicationAwareWireframe.h"

@protocol RTCaptureThumbnailViewControllerFactory;
@class RTUploadVideoWireframe;

@interface RTCaptureThumbnailWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewControllerFactory:(id<RTCaptureThumbnailViewControllerFactory>)viewControllerFactory
                         uploadVideoWireframe:(RTUploadVideoWireframe *)uploadVideoWireframe
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentCaptureThumbnailInterfaceForVideo:(NSURL *)videoURL;

- (void)presentUploadVideoInterfaceForVideo:(NSURL *)videoURL
                                  thumbnail:(NSURL *)thumbnailURL;
@end
