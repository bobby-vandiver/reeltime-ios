#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RTApplicationTabBarController;
@class RTLoginWireframe;
@class RTBrowseAllViewController;
@class RTUserProfileViewController;

@interface RTApplicationWireframe : NSObject

@property RTBrowseAllViewController *browseViewController;

@property RTUserProfileViewController *userProfileViewController;

- (instancetype)initWithWindow:(UIWindow *)window
              tabBarController:(RTApplicationTabBarController *)tabBarController
                loginWireframe:(RTLoginWireframe *)loginWireframe;

- (void)presentInitialScreen;

- (void)presentTabBarManagedScreen;

@end
