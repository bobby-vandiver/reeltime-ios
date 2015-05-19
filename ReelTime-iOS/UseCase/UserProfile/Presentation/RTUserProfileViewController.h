#import "RTPagedListViewController.h"

#import "RTUserSummaryView.h"
#import "RTBrowseReelsView.h"
#import "RTStoryboardViewController.h"

@class RTUserSummaryPresenter;
@class RTBrowseReelsPresenter;
@class RTThumbnailSupport;

@protocol RTBrowseReelVideosPresenterFactory;
@protocol RTVideoWireframe;

@class RTArrayDataSource;

@interface RTUserProfileViewController : RTPagedListViewController <RTUserSummaryView, RTBrowseReelsView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITableView *reelsListTableView;

+ (instancetype)viewControllerForUsername:(NSString *)username
                        withUserPresenter:(RTUserSummaryPresenter *)userPresenter
                           reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter
               reelVideosPresenterFactory:(id<RTBrowseReelVideosPresenterFactory>)reelVideosPresenterFactory
                      reelVideosWireframe:(id<RTVideoWireframe>)reelVideosWireframe
                         thumbnailSupport:(RTThumbnailSupport *)thumbnailSupport;

@end
