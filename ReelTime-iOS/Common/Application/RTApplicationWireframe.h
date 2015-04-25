#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RTApplicationTabBarController;
@class RTApplicationWireframeContainer;

@interface RTApplicationWireframe : NSObject

- (instancetype)initWithWindow:(UIWindow *)window
              tabBarController:(RTApplicationTabBarController *)tabBarController
            wireframeContainer:(RTApplicationWireframeContainer *)wireframeContainer;

- (void)presentInitialScreen;

- (void)presentTabBarManagedScreen;

@end
