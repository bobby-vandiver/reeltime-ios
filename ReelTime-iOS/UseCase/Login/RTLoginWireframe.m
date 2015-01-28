#import "RTLoginWireframe.h"
#import "RTLoginViewController.h"

#import "RTStoryboardViewControllerFactory.h"

@interface RTLoginWireframe ()

@property RTLoginViewController *viewController;

@end

@implementation RTLoginWireframe

- (instancetype)initWithViewController:(RTLoginViewController *)viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)presentLoginInterfaceFromWindow:(UIWindow *)window {
    window.rootViewController = self.viewController;
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

@end
