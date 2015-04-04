#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RTApplicationTabBarController;
@class RTLoginWireframe;
@class RTBrowseAllViewController;

@interface RTApplicationWireframe : NSObject

@property RTBrowseAllViewController *browseViewController;

- (instancetype)initWithWindow:(UIWindow *)window
              tabBarController:(RTApplicationTabBarController *)tabBarController
                loginWireframe:(RTLoginWireframe *)loginWireframe;

- (void)presentInitialScreen;

- (void)presentTabBarManagedScreen;

@end
