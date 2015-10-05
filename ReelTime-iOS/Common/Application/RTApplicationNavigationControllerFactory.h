#import <Foundation/Foundation.h>

@class RTApplicationNavigationController;

@protocol RTApplicationNavigationControllerFactory <NSObject>

- (RTApplicationNavigationController *)applicationNavigationController;

@end
