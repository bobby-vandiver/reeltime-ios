#import "RTLoginWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTLoginViewController.h"
#import "RTAccountRegistrationWireframe.h"

@interface RTLoginWireframe ()

@property RTLoginViewController *viewController;
@property RTAccountRegistrationWireframe *accountRegistrationWireframe;

@end

@implementation RTLoginWireframe

- (instancetype)initWithViewController:(RTLoginViewController *)viewController
          accountRegistrationWireframe:(RTAccountRegistrationWireframe *)accountRegistrationWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {
    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
        self.accountRegistrationWireframe = accountRegistrationWireframe;
    }
    return self;
}

- (void)presentLoginInterface {
    [self.applicationWireframe presentNavigationRootViewController:self.viewController];
}

- (void)presentPostLoginInterface {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Post Login"
                                                        message:@"Login Succeeded"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)presentDeviceRegistrationInterface {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Register Device"
                                                        message:@"Unknown Device"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)presentAccountRegistrationInterface {
    [self.accountRegistrationWireframe presentAccountRegistrationInterface];
}

@end
