#import "RTApplicationAwareWireframe.h"

@class RTRecordVideoViewController;

@interface RTRecordVideoWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTRecordVideoViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentVideoCameraInterface;

@end
