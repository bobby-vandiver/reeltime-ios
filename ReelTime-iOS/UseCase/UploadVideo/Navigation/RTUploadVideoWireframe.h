#import "RTApplicationAwareWireframe.h"

@protocol RTUploadVideoViewControllerFactory;

@interface RTUploadVideoWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewControllerFactory:(id<RTUploadVideoViewControllerFactory>)viewControllerFactory
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentUploadVideoInterfaceForVideo:(NSURL *)videoUrl
                                  thumbnail:(NSURL *)thumbnail;

@end
