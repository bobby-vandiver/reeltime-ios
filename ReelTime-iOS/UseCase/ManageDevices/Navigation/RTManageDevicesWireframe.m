#import "RTManageDevicesWireframe.h"
#import "RTManageDevicesViewController.h"

#import "RTApplicationWireframe.h"

@interface RTManageDevicesWireframe ()

@property RTManageDevicesViewController *viewController;

@end

@implementation RTManageDevicesWireframe

- (instancetype)initWithViewController:(RTManageDevicesViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)presentManageDevicesInterface {
    [self.applicationWireframe navigateToViewController:self.viewController];
}

@end
