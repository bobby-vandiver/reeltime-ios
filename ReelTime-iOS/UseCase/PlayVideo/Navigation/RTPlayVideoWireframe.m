#import "RTPlayVideoWireframe.h"

#import "RTPlayVideoViewController.h"
#import "RTPlayVideoViewControllerFactory.h"

#import "RTApplicationWireframe.h"

@interface RTPlayVideoWireframe ()

@property id<RTPlayVideoViewControllerFactory> viewControllerFactory;

@end

@implementation RTPlayVideoWireframe

- (instancetype)initWithViewControllerFactory:(id<RTPlayVideoViewControllerFactory>)viewControllerFactory
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewControllerFactory = viewControllerFactory;
    }
    return self;
}

- (void)presentVideoForVideoId:(NSNumber *)videoId {
    RTPlayVideoViewController *viewController = [self.viewControllerFactory playVideoViewControllerForVideoId:videoId];
    [self.applicationWireframe navigateToViewController:viewController];
}

@end
