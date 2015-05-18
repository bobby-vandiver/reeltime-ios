#import "RTLoginWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTLoginViewController.h"

#import "RTAccountRegistrationWireframe.h"
#import "RTDeviceRegistrationWireframe.h"
#import "RTResetPasswordWireframe.h"

#import "RTLogging.h"

@interface RTLoginWireframe ()

@property RTLoginViewController *viewController;

@property RTAccountRegistrationWireframe *accountRegistrationWireframe;
@property RTDeviceRegistrationWireframe *deviceRegistrationWireframe;
@property RTResetPasswordWireframe *resetPasswordWireframe;

@end

@implementation RTLoginWireframe

- (instancetype)initWithViewController:(RTLoginViewController *)viewController
          accountRegistrationWireframe:(RTAccountRegistrationWireframe *)accountRegistrationWireframe
           deviceRegistrationWireframe:(RTDeviceRegistrationWireframe *)deviceRegistrationWireframe
                resetPasswordWireframe:(RTResetPasswordWireframe *)resetPasswordWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {
    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
        self.accountRegistrationWireframe = accountRegistrationWireframe;
        self.deviceRegistrationWireframe = deviceRegistrationWireframe;
        self.resetPasswordWireframe = resetPasswordWireframe;
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

- (void)presentResetPasswordInterface {
    DDLogDebug(@"Presenting reset password");
    [self.resetPasswordWireframe presentResetPasswordEmailInterface];
}

@end
