#import "RTApplicationAwareWireframe.h"

@class RTLoginViewController;

@class RTAccountRegistrationWireframe;
@class RTDeviceRegistrationWireframe;
@class RTResetPasswordWireframe;

@interface RTLoginWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTLoginViewController *)viewController
          accountRegistrationWireframe:(RTAccountRegistrationWireframe *)accountRegistrationWireframe
           deviceRegistrationWireframe:(RTDeviceRegistrationWireframe *)deviceRegistrationWireframe
                resetPasswordWireframe:(RTResetPasswordWireframe *)resetPasswordWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentLoginInterface;

- (void)presentPostLoginInterface;

- (void)presentDeviceRegistrationInterface;

- (void)presentAccountRegistrationInterface;

- (void)presentResetPasswordInterface;

@end
