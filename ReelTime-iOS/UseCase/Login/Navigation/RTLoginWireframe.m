#import "RTLoginWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTLoginViewController.h"

#import "RTAccountRegistrationWireframe.h"
#import "RTDeviceRegistrationWireframe.h"

#import "RTLogging.h"

@interface RTLoginWireframe ()

@property RTLoginViewController *viewController;

@property RTAccountRegistrationWireframe *accountRegistrationWireframe;
@property RTDeviceRegistrationWireframe *deviceRegistrationWireframe;

@end

@implementation RTLoginWireframe

- (instancetype)initWithViewController:(RTLoginViewController *)viewController
          accountRegistrationWireframe:(RTAccountRegistrationWireframe *)accountRegistrationWireframe
           deviceRegistrationWireframe:(RTDeviceRegistrationWireframe *)deviceRegistrationWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {
    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
        self.accountRegistrationWireframe = accountRegistrationWireframe;
        self.deviceRegistrationWireframe = deviceRegistrationWireframe;
    }
    return self;
}

- (void)presentLoginInterface {
    [self.applicationWireframe presentNavigationRootViewController:self.viewController];
}

- (void)presentPostLoginInterface {
    DDLogDebug(@"Login succeeded");

    // TODO: Present record video interface when available
}

- (void)presentDeviceRegistrationInterface {
    DDLogWarn(@"Attempting to login from unrecognized device");
    [self.deviceRegistrationWireframe presentDeviceRegistrationInterface];
}

- (void)presentAccountRegistrationInterface {
    DDLogDebug(@"Presenting new account registration");
    [self.accountRegistrationWireframe presentAccountRegistrationInterface];
}

@end
