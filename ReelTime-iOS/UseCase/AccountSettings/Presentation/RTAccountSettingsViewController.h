#import <UIKit/UIKit.h>
#import "RTStoryboardViewController.h"

@class RTAccountSettingsPresenter;

@interface RTAccountSettingsViewController : UITableViewController <RTStoryboardViewController>

+ (instancetype)viewControllerWithPresenter:(RTAccountSettingsPresenter *)presenter;

@end
