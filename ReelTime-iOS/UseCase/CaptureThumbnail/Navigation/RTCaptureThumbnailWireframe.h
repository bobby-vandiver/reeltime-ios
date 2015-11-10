#import "RTApplicationAwareWireframe.h"

@protocol RTCaptureThumbnailViewControllerFactory;

@interface RTCaptureThumbnailWireframe : RTApplicationAwareWireframe

// TODO: Inject upload video wireframe and add plumbing
- (instancetype)initWithViewControllerFactory:(id<RTCaptureThumbnailViewControllerFactory>)viewControllerFactory
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentCaptureThumbnailInterfaceForVideo:(NSURL *)videoURL;

- (void)presentUploadVideoInterfaceForVideo:(NSURL *)videoUrl
                                  thumbnail:(NSURL *)thumbnailUrl;
@end
