#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RTApplicationNavigationController;
@class RTApplicationTabBarController;
@class RTApplicationWireframeContainer;

@interface RTApplicationWireframe : NSObject

- (instancetype)initWithWindow:(UIWindow *)window
          navigationController:(RTApplicationNavigationController *)navigationController
              tabBarController:(RTApplicationTabBarController *)tabBarController
            wireframeContainer:(RTApplicationWireframeContainer *)wireframeContainer;

- (void)presentInitialScreen;

- (void)presentTabBarManagedScreen;

- (void)presentNavigationRootViewController:(UIViewController *)viewController;

@end
