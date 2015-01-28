#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RTAccountRegistrationViewController;

@interface RTAccountRegistrationWireframe : NSObject

- (instancetype)initWithViewController:(RTAccountRegistrationViewController *)viewController;

- (void)presentAccountRegistrationInterfaceFromWindow:(UIWindow *)window;

- (void)presentLoginInterface;

- (void)presentPostAutoLoginInterface;

- (void)presentDeviceRegistrationInterface;

@end
