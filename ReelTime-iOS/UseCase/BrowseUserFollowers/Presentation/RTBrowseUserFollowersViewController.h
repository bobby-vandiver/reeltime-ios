#import "RTPagedListViewController.h"

#import "RTBrowseUsersView.h"
#import "RTStoryboardViewController.h"

@class RTBrowseUsersPresenter;

@interface RTBrowseUserFollowersViewController : RTPagedListViewController <RTBrowseUsersView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITableView *browseUserFollowersTableView;

+ (instancetype)viewControllerWithUsersPresenter:(RTBrowseUsersPresenter *)usersPresenter;

@end
