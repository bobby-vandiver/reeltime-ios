#import "RTPagedListViewController.h"

#import "RTBrowseUsersView.h"
#import "RTBrowseReelsView.h"
#import "RTBrowseVideosView.h"
#import "RTStoryboardViewController.h"

@class RTBrowseUsersPresenter;
@class RTBrowseReelsPresenter;
@class RTBrowseVideosPresenter;

@interface RTBrowseAllViewController : RTPagedListViewController <RTBrowseUsersView, RTBrowseReelsView, RTBrowseVideosView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *browseListTableView;

+ (instancetype)viewControllerWithUsersPresenter:(RTBrowseUsersPresenter *)usersPresenter
                                  reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter
                                 videosPresenter:(RTBrowseVideosPresenter *)videosPresenter;

- (IBAction)segmentedControlChanged;

@end
