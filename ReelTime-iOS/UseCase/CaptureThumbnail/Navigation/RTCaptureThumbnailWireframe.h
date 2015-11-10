#import "RTApplicationAwareWireframe.h"

@protocol RTCaptureThumbnailViewControllerFactory;

@interface RTCaptureThumbnailWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewControllerFactory:(id<RTCaptureThumbnailViewControllerFactory>)viewControllerFactory
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentCaptureThumbnailInterfaceForVideo:(NSURL *)videoURL;

@end
