#import "RTRecordVideoWireframe.h"
#import "RTRecordVideoViewController.h"

#import "RTCaptureThumbnailWireframe.h"
#import "RTApplicationWireframe.h"

@interface RTRecordVideoWireframe ()

@property RTRecordVideoViewController *viewController;
@property RTCaptureThumbnailWireframe *captureThumbnailWireframe;

@end


@implementation RTRecordVideoWireframe

- (instancetype)initWithViewController:(RTRecordVideoViewController *)viewController
             captureThumbnailWireframe:(RTCaptureThumbnailWireframe *)captureThumbnailWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
        self.captureThumbnailWireframe = captureThumbnailWireframe;
    }
    return self;
}

- (void)presentVideoCameraInterface {
    [self.applicationWireframe navigateToViewController:self.viewController];
}

- (void)presentCaptureThumbnailInterfaceForVideo:(NSURL *)videoURL {
    [self.captureThumbnailWireframe presentCaptureThumbnailInterfaceForVideo:videoURL];
}

@end
