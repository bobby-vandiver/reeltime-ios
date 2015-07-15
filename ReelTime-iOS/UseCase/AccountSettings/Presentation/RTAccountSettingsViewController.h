#import <UIKit/UIKit.h>

#import "RTLogoutView.h"
#import "RTStoryboardViewController.h"

@class RTAccountSettingsPresenter;

@interface RTAccountSettingsViewController : UITableViewController <RTLogoutView, RTStoryboardViewController>

+ (instancetype)viewControllerWithPresenter:(RTAccountSettingsPresenter *)presenter;

@end
