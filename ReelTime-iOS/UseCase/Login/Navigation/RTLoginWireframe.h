#import "RTApplicationAwareWireframe.h"

@class RTLoginViewController;

@class RTAccountRegistrationWireframe;
@class RTDeviceRegistrationWireframe;

@interface RTLoginWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTLoginViewController *)viewController
          accountRegistrationWireframe:(RTAccountRegistrationWireframe *)accountRegistrationWireframe
           deviceRegistrationWireframe:(RTDeviceRegistrationWireframe *)deviceRegistrationWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentLoginInterface;

- (void)presentPostLoginInterface;

- (void)presentDeviceRegistrationInterface;

- (void)presentAccountRegistrationInterface;

@end
