#import "RTAccountRegistrationWireframe.h"
#import "RTAccountRegistrationViewController.h"

@interface RTAccountRegistrationWireframe ()

@property RTAccountRegistrationViewController *viewController;

@end

@implementation RTAccountRegistrationWireframe

- (instancetype)initWithViewController:(RTAccountRegistrationViewController *)viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)presentAccountRegistrationInterfaceFromWindow:(UIWindow *)window {
    window.rootViewController = self.viewController;
}

- (void)presentLoginInterface {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Present Login"
                                                        message:@"Registration succeeded, but auto-login failed"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)presentPostAutoLoginInterface {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Post Auto Login"
                                                        message:@"Registration and auto login succeeded"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)presentDeviceRegistrationInterface {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Present Device Registration"
                                                        message:@"Registration succeeded but unable to associate device with account"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
