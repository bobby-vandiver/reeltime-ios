#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RTApplicationNavigationController;
@class RTApplicationTabBarController;
@class RTApplicationWireframeContainer;

@protocol RTApplicationNavigationControllerFactory;

@interface RTApplicationWireframe : NSObject

- (instancetype)initWithWindow:(UIWindow *)window
              tabBarController:(RTApplicationTabBarController *)tabBarController
            wireframeContainer:(RTApplicationWireframeContainer *)wireframeContainer
   navigationControllerFactory:(id<RTApplicationNavigationControllerFactory>)navigationControllerFactory;

- (void)presentInitialScreen;

- (void)presentPreviousScreen;

- (void)presentTabBarManagedScreen;

- (void)presentNavigationRootViewController:(UIViewController *)viewController;

- (void)navigateToViewController:(UIViewController *)viewController;

- (BOOL)isVisibleViewController:(UIViewController *)viewController;

@end
