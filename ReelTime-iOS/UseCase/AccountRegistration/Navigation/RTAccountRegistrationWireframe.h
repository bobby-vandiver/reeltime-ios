#import "RTApplicationAwareWireframe.h"

@class RTAccountRegistrationViewController;
@class RTLoginWireframe;
@class RTDeviceRegistrationWireframe;

@interface RTAccountRegistrationWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTAccountRegistrationViewController *)viewController
                        loginWireframe:(RTLoginWireframe *)loginWireframe
           deviceRegistrationWireframe:(RTDeviceRegistrationWireframe *)deviceRegistrationWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentAccountRegistrationInterface;

- (void)presentLoginInterface;

- (void)presentPostAutoLoginInterface;

- (void)presentDeviceRegistrationInterface;

@end
