#import "RTUploadVideoWireframe.h"
#import "RTRecordVideoWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTUploadVideoViewController.h"
#import "RTUploadVideoViewControllerFactory.h"

@interface RTUploadVideoWireframe ()

@property id<RTUploadVideoViewControllerFactory> viewControllerFactory;
@property RTRecordVideoWireframe *recordVideoWireframe;

@end

@implementation RTUploadVideoWireframe

- (instancetype)initWithViewControllerFactory:(id<RTUploadVideoViewControllerFactory>)viewControllerFactory
                         recordVideoWireframe:(RTRecordVideoWireframe *)recordVideoWireframe
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewControllerFactory = viewControllerFactory;
        self.recordVideoWireframe = recordVideoWireframe;
    }
    return self;
}

- (void)presentUploadVideoInterfaceForVideo:(NSURL *)videoUrl
                                  thumbnail:(NSURL *)thumbnailUrl {
    RTUploadVideoViewController *viewController = [self.viewControllerFactory uploadVideoViewControllerForVideo:videoUrl
                                                                                                      thumbnail:thumbnailUrl];
    [self.applicationWireframe navigateToViewController:viewController];
}

- (void)presentVideoCameraInterface {
    [self.recordVideoWireframe presentVideoCameraInterface];
}

@end
