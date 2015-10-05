#import <UIKit/UIKit.h>

// Custom navigation controller that allows the root view controller
// to be changed post-initialization.
//
// Source: https://starterstep.wordpress.com/2009/03/05/changing-a-uinavigationcontroller%E2%80%99s-root-view-controller/

@interface RTApplicationNavigationController : UINavigationController

@property UIViewController *rootViewController;

@end
