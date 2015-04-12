#import "RTPagedListViewController.h"

#import "RTBrowseUsersView.h"
#import "RTBrowseReelsView.h"
#import "RTBrowseVideosView.h"
#import "RTStoryboardViewController.h"

@class RTBrowseUsersPresenter;
@class RTBrowseReelsPresenter;
@class RTBrowseVideosPresenter;
@class RTArrayDataSource;

@interface RTBrowseAllViewController : RTPagedListViewController <RTBrowseUsersView, RTBrowseReelsView, RTBrowseVideosView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *browseListTableView;

+ (RTBrowseAllViewController *)viewControllerWithUsersPresenter:(RTBrowseUsersPresenter *)usersPresenter
                                                 reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter
                                                videosPresenter:(RTBrowseVideosPresenter *)videosPresenter;

- (IBAction)segmentedControlChanged;

@end
