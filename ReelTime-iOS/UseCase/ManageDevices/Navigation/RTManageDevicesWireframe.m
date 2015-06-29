#import "RTManageDevicesWireframe.h"
#import "RTManageDevicesViewController.h"

#import "RTLoginWireframe.h"
#import "RTApplicationWireframe.h"

@interface RTManageDevicesWireframe ()

@property RTManageDevicesViewController *viewController;
@property RTLoginWireframe *loginWireframe;

@end

@implementation RTManageDevicesWireframe

- (instancetype)initWithViewController:(RTManageDevicesViewController *)viewController
                        loginWireframe:(RTLoginWireframe *)loginWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
        self.loginWireframe = loginWireframe;
    }
    return self;
}

- (void)presentManageDevicesInterface {
    [self.applicationWireframe navigateToViewController:self.viewController];
}

- (void)presentLoginInterface {
    [self.loginWireframe presentLoginInterface];
}

@end
