#import "RTApplicationAwareWireframe.h"

@class RTResetPasswordViewController;
@class RTLoginWireframe;

@interface RTResetPasswordWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTResetPasswordViewController *)viewController
                        loginWireframe:(RTLoginWireframe *)loginWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentResetPasswordEmailInterface;

- (void)presentResetPasswordInterface;

- (void)presentLoginInterface;

@end
