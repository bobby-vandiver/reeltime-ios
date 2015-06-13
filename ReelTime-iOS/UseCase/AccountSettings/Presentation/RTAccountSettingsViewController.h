#import <UIKit/UIKit.h>
#import "RTStoryboardViewController.h"

@class RTAccountSettingsPresenter;

@interface RTAccountSettingsViewController : UIViewController <RTStoryboardViewController>

+ (instancetype)viewControllerWithPresenter:(RTAccountSettingsPresenter *)presenter;

@end
