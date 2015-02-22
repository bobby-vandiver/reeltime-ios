#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RTApplicationTabBarController;
@class RTLoginWireframe;

@interface RTApplicationWireframe : NSObject

- (instancetype)initWithWindow:(UIWindow *)window
              tabBarController:(RTApplicationTabBarController *)tabBarController
                loginWireframe:(RTLoginWireframe *)loginWireframe;

- (void)presentInitialScreen;

- (void)presentTabBarManagedScreen;

@end
