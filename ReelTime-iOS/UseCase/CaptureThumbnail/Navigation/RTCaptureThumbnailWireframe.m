#import "RTCaptureThumbnailWireframe.h"
#import "RTUploadVideoWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTCaptureThumbnailViewController.h"
#import "RTCaptureThumbnailViewControllerFactory.h"

@interface RTCaptureThumbnailWireframe ()

@property id<RTCaptureThumbnailViewControllerFactory> viewControllerFactory;
@property RTUploadVideoWireframe *uploadVideoWireframe;

@end

@implementation RTCaptureThumbnailWireframe

- (instancetype)initWithViewControllerFactory:(id<RTCaptureThumbnailViewControllerFactory>)viewControllerFactory
                         uploadVideoWireframe:(RTUploadVideoWireframe *)uploadVideoWireframe
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewControllerFactory = viewControllerFactory;
        self.uploadVideoWireframe = uploadVideoWireframe;
    }
    return self;
}

- (void)presentCaptureThumbnailInterfaceForVideo:(NSURL *)videoURL {
    RTCaptureThumbnailViewController *viewController = [self.viewControllerFactory captureThumbnailViewControllerForVideo:videoURL];
    [self.applicationWireframe navigateToViewController:viewController];
}

- (void)presentUploadVideoInterfaceForVideo:(NSURL *)videoURL
                                  thumbnail:(NSURL *)thumbnailURL {
    [self.uploadVideoWireframe presentUploadVideoInterfaceForVideo:videoURL thumbnail:thumbnailURL];
}

@end
