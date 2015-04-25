#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RTLoginViewController;
@class RTAccountRegistrationWireframe;

@interface RTLoginWireframe : NSObject

- (instancetype)initWithViewController:(RTLoginViewController *)viewController
          accountRegistrationWireframe:(RTAccountRegistrationWireframe *)accountRegistrationWireframe;

- (void)presentLoginInterface;

- (void)presentPostLoginInterface;

- (void)presentDeviceRegistrationInterface;

- (void)presentAccountRegistrationInterface;

@end
