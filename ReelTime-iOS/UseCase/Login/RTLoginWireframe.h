#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RTLoginPresenter;
@class RTLoginViewController;

@interface RTLoginWireframe : NSObject

- (instancetype)initWithPresenter:(RTLoginPresenter *)presenter
                   viewController:(RTLoginViewController *)viewController;

- (void)presentLoginInterfaceFromWindow:(UIWindow *)window;

- (void)presentPostLoginInterface;

- (void)presentDeviceRegistrationInterface;

@end
