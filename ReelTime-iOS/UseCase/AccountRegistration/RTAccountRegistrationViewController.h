#import <UIKit/UIKit.h>

#import "RTAccountRegistrationView.h"
#import "RTStoryboardViewController.h"

@class RTAccountRegistrationPresenter;

@interface RTAccountRegistrationViewController : UIViewController <RTAccountRegistrationView, RTStoryboardViewController>

+ (RTAccountRegistrationViewController *)viewControllerWithPresenter:(RTAccountRegistrationPresenter *)presenter;

@end
