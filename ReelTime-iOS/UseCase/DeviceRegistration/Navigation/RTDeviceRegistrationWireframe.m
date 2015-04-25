#import "RTDeviceRegistrationWireframe.h"
#import "RTDeviceRegistrationViewController.h"

#import "RTLoginWireframe.h"
#import "RTApplicationWireframe.h"

@interface RTDeviceRegistrationWireframe ()

@property RTDeviceRegistrationViewController *viewController;
@property RTLoginWireframe *loginWireframe;

@end

@implementation RTDeviceRegistrationWireframe

- (instancetype)initWithViewController:(RTDeviceRegistrationViewController *)viewController
                        loginWireframe:(RTLoginWireframe *)loginWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {
    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
        self.loginWireframe = loginWireframe;
    }
    return self;
}

- (void)presentDeviceRegistrationInterface {
    [self.applicationWireframe navigateToViewController:self.viewController];
}

- (void)presentLoginInterface {
    [self.loginWireframe presentLoginInterface];
}

@end
