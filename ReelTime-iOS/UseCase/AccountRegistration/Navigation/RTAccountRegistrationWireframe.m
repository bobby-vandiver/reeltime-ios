#import "RTAccountRegistrationWireframe.h"
#import "RTAccountRegistrationViewController.h"

#import "RTLoginWireframe.h"
#import "RTDeviceRegistrationWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTLogging.h"

@interface RTAccountRegistrationWireframe ()

@property RTAccountRegistrationViewController *viewController;

@property RTLoginWireframe *loginWireframe;
@property RTDeviceRegistrationWireframe *deviceRegistrationWireframe;

@end

@implementation RTAccountRegistrationWireframe

- (instancetype)initWithViewController:(RTAccountRegistrationViewController *)viewController
                        loginWireframe:(RTLoginWireframe *)loginWireframe
           deviceRegistrationWireframe:(RTDeviceRegistrationWireframe *)deviceRegistrationWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {
    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
        self.loginWireframe = loginWireframe;
        self.deviceRegistrationWireframe = deviceRegistrationWireframe;
    }
    return self;
}

- (void)presentAccountRegistrationInterface {
    [self.applicationWireframe navigateToViewController:self.viewController];
}

- (void)presentLoginInterface {
    DDLogDebug(@"Registration succeeded, but auto-login failed");
    [self.loginWireframe presentLoginInterface];
}

- (void)presentPostAutoLoginInterface {
    DDLogDebug(@"Registration and auto login succeeded");
    [self.loginWireframe presentPostLoginInterface];
}

- (void)presentDeviceRegistrationInterface {
    DDLogDebug(@"Registration succeeded, but unable to associate device with account");
    [self.deviceRegistrationWireframe presentDeviceRegistrationInterface];
}

@end
