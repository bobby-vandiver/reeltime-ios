#import <UIKit/UIKit.h>

#import "RTLoginView.h"
#import "RTStoryboardViewController.h"

@class RTLoginPresenter;

@interface RTLoginViewController : UIViewController <RTLoginView, RTStoryboardViewController>

+ (RTLoginViewController *)viewControllerWithPresenter:(RTLoginPresenter *)presenter;

@end
