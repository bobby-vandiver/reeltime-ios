#import "RTUploadVideoWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTUploadVideoViewController.h"
#import "RTUploadVideoViewControllerFactory.h"

@interface RTUploadVideoWireframe ()

@property id<RTUploadVideoViewControllerFactory> viewControllerFactory;

@end

@implementation RTUploadVideoWireframe

- (instancetype)initWithViewControllerFactory:(id<RTUploadVideoViewControllerFactory>)viewControllerFactory
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewControllerFactory = viewControllerFactory;
    }
    return self;
}

- (void)presentUploadVideoInterfaceForVideo:(NSURL *)videoUrl
                                  thumbnail:(NSURL *)thumbnail {
    
}

@end
