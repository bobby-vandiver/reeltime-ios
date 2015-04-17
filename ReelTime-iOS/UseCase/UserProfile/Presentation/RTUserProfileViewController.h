#import "RTPagedListViewController.h"

#import "RTUserSummaryView.h"
#import "RTBrowseReelsView.h"
#import "RTStoryboardViewController.h"

@class RTUserSummaryPresenter;
@class RTBrowseReelsPresenter;
@protocol RTBrowseReelVideosPresenterFactory;

@class RTArrayDataSource;

@interface RTUserProfileViewController : RTPagedListViewController <RTUserSummaryView, RTBrowseReelsView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITableView *reelsListTableView;

+ (RTUserProfileViewController *)viewControllerForUsername:(NSString *)username
                                         withUserPresenter:(RTUserSummaryPresenter *)userPresenter
                                            reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter
                                reelVideosPresenterFactory:(id<RTBrowseReelVideosPresenterFactory>)reelVideosPresenterFactory;

@end
