#import "RTPagedListViewController.h"

#import "RTManageDevicesView.h"
#import "RTStoryboardViewController.h"

@class RTManageDevicesPresenter;

@interface RTManageDevicesViewController : RTPagedListViewController <RTManageDevicesView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITableView *clientListTableView;

+ (instancetype)viewControllerWithPresenter:(RTManageDevicesPresenter *)presenter;

@end
