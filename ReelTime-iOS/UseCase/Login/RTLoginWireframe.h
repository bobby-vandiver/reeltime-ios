#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RTLoginViewController;

@interface RTLoginWireframe : NSObject

- (instancetype)initWithViewController:(RTLoginViewController *)viewController;

- (void)presentLoginInterfaceFromWindow:(UIWindow *)window;

- (void)presentPostLoginInterface;

- (void)presentDeviceRegistrationInterface;

@end
