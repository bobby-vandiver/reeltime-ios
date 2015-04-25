#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "RTApplicationAwareWireframe.h"

@class RTLoginViewController;
@class RTAccountRegistrationWireframe;

@interface RTLoginWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTLoginViewController *)viewController
          accountRegistrationWireframe:(RTAccountRegistrationWireframe *)accountRegistrationWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentLoginInterface;

- (void)presentPostLoginInterface;

- (void)presentDeviceRegistrationInterface;

- (void)presentAccountRegistrationInterface;

@end
