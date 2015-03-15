#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RTApplicationTabBarController;
@class RTLoginWireframe;
@class RTBrowseViewController;

@interface RTApplicationWireframe : NSObject

@property RTBrowseViewController *browseViewController;

- (instancetype)initWithWindow:(UIWindow *)window
              tabBarController:(RTApplicationTabBarController *)tabBarController
                loginWireframe:(RTLoginWireframe *)loginWireframe;

- (void)presentInitialScreen;

- (void)presentTabBarManagedScreen;

@end
