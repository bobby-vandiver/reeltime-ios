#import "RTPagedListViewController.h"

#import "RTBrowseUsersView.h"
#import "RTStoryboardViewController.h"

@class RTBrowseUsersPresenter;

@interface RTBrowseAudienceMembersViewController : RTPagedListViewController <RTBrowseUsersView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITableView *browseAudienceMembersTableView;

+ (instancetype)viewControllerWithUsersPresenter:(RTBrowseUsersPresenter *)usersPresenter;

@end
