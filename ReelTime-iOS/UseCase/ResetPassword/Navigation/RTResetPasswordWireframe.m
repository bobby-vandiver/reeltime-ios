#import "RTResetPasswordWireframe.h"
#import "RTResetPasswordViewController.h"
#import "RTLoginWireframe.h"

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
    
}

- (void)presentResetPasswordInterface {
    
}

- (void)presentLoginInterface {
    
}

@end
