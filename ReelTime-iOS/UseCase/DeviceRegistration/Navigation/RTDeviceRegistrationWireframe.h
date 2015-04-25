#import "RTApplicationAwareWireframe.h"

@class RTDeviceRegistrationViewController;
@class RTLoginWireframe;

@interface RTDeviceRegistrationWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTDeviceRegistrationViewController *)viewController
                        loginWireframe:(RTLoginWireframe *)loginWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentDeviceRegistrationInterface;

- (void)presentLoginInterface;

@end
