#import <Foundation/Foundation.h>

@class RTApplicationNavigationController;

@protocol RTApplicationNavigationControllerFactory <NSObject>

- (RTApplicationNavigationController *)applicationNavigationControllerWithRootViewController:(UIViewController *)rootViewController;

@end
