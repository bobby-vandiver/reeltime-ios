#import "RTResetPasswordWireframe.h"
#import "RTResetPasswordViewController.h"

#import "RTLoginWireframe.h"
#import "RTApplicationWireframe.h"

@interface RTResetPasswordWireframe ()

@property RTResetPasswordViewController *viewController;
@property RTLoginWireframe *loginWireframe;

@end

@implementation RTResetPasswordWireframe

- (instancetype)initWithViewController:(RTResetPasswordViewController *)viewController
                        loginWireframe:(RTLoginWireframe *)loginWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe {
    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
        self.loginWireframe = loginWireframe;
    }
    return self;
}

- (void)presentResetPasswordEmailInterface {
    [self.applicationWireframe navigateToViewController:self.viewController];
}

- (void)presentResetPasswordInterface {
    if (![self.applicationWireframe isVisibleViewController:self.viewController]) {
        [self.applicationWireframe navigateToViewController:self.viewController];
    }
}

- (void)presentLoginInterface {
    [self.loginWireframe presentLoginInterface];
}

@end
