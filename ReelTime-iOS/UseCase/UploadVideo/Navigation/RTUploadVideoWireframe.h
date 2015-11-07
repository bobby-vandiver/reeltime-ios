#import "RTApplicationAwareWireframe.h"

@protocol RTUploadVideoViewControllerFactory;
@class RTRecordVideoWireframe;

@interface RTUploadVideoWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewControllerFactory:(id<RTUploadVideoViewControllerFactory>)viewControllerFactory
                         recordVideoWireframe:(RTRecordVideoWireframe *)recordVideoWireframe
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentUploadVideoInterfaceForVideo:(NSURL *)videoUrl
                                  thumbnail:(NSURL *)thumbnailUrl;

- (void)presentVideoCameraInterface;

@end
