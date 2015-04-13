#import "RTPagedListViewController.h"

#import "RTUserSummaryView.h"
#import "RTBrowseReelsView.h"
#import "RTStoryboardViewController.h"

@class RTUserProfileAssembly;

@class RTUserSummaryPresenter;
@class RTBrowseReelsPresenter;
@class RTArrayDataSource;

@interface RTUserProfileViewController : RTPagedListViewController <RTUserSummaryView, RTBrowseReelsView, RTStoryboardViewController>

@property RTUserProfileAssembly *userProfileAssembly;

@property (weak, nonatomic) IBOutlet UITableView *reelsListTableView;

+ (RTUserProfileViewController *)viewControllerForUsername:(NSString *)username
                                         withUserPresenter:(RTUserSummaryPresenter *)userPresenter
                                            reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter;

@end
