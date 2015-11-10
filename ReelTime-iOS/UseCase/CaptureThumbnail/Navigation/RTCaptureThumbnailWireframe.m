#import "RTCaptureThumbnailWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTCaptureThumbnailViewController.h"
#import "RTCaptureThumbnailViewControllerFactory.h"

@interface RTCaptureThumbnailWireframe ()

@property id<RTCaptureThumbnailViewControllerFactory> viewControllerFactory;

@end

@implementation RTCaptureThumbnailWireframe

- (instancetype)initWithViewControllerFactory:(id<RTCaptureThumbnailViewControllerFactory>)viewControllerFactory
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewControllerFactory = viewControllerFactory;
    }
    return self;
}

- (void)presentCaptureThumbnailInterfaceForVideo:(NSURL *)videoURL {
    RTCaptureThumbnailViewController *viewController = [self.viewControllerFactory captureThumbnailViewControllerForVideo:videoURL];
    [self.applicationWireframe navigateToViewController:viewController];
}

@end
