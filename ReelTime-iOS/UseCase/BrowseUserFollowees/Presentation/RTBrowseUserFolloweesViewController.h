#import "RTPagedListViewController.h"

#import "RTBrowseUsersView.h"
#import "RTStoryboardViewController.h"

@class RTBrowseUsersPresenter;

@interface RTBrowseUserFolloweesViewController : RTPagedListViewController <RTBrowseUsersView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITableView *browseUserFolloweesTableView;

+ (instancetype)viewControllerWithUsersPresenter:(RTBrowseUsersPresenter *)usersPresenter;

@end
