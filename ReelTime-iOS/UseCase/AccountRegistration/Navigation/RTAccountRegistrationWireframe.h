#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "RTApplicationAwareWireframe.h"

@class RTAccountRegistrationViewController;
@class RTApplicationWireframe;

@interface RTAccountRegistrationWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTAccountRegistrationViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentAccountRegistrationInterface;

- (void)presentLoginInterface;

- (void)presentPostAutoLoginInterface;

- (void)presentDeviceRegistrationInterface;

@end
