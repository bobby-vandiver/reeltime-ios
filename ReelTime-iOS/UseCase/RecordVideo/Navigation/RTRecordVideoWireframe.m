#import "RTRecordVideoWireframe.h"
#import "RTRecordVideoViewController.h"

#import "RTApplicationWireframe.h"

@interface RTRecordVideoWireframe ()

@property RTRecordVideoViewController *viewController;

@end


@implementation RTRecordVideoWireframe

- (instancetype)initWithViewController:(RTRecordVideoViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {
    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)presentVideoCameraInterface {
    [self.applicationWireframe navigateToViewController:self.viewController];
}

@end
