#import "RTPagedListViewController.h"

#import "RTBrowseUsersView.h"
#import "RTBrowseReelsView.h"
#import "RTBrowseVideosView.h"
#import "RTStoryboardViewController.h"

@class RTBrowseUsersPresenter;
@class RTBrowseReelsPresenter;
@class RTBrowseVideosPresenter;
@class RTArrayDataSource;

@interface RTBrowseViewController : RTPagedListViewController <RTBrowseUsersView, RTBrowseReelsView, RTBrowseVideosView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

+ (RTBrowseViewController *)viewControllerWithUsersPresenter:(RTBrowseUsersPresenter *)usersPresenter
                                              reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter
                                             videosPresenter:(RTBrowseVideosPresenter *)videosPresenter;

- (IBAction)segmentedControlChanged;

@end
