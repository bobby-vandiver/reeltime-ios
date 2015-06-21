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

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *subscribersLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscribedToLabel;

@property (weak, nonatomic) IBOutlet UILabel *reelsCreatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *reelsFollowingLabel;

@property (weak, nonatomic) IBOutlet UITableView *reelsListTableView;

+ (instancetype)viewControllerForUsername:(NSString *)username
                        withUserPresenter:(RTUserSummaryPresenter *)userPresenter
                           reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter
               reelVideosPresenterFactory:(id<RTBrowseReelVideosPresenterFactory>)reelVideosPresenterFactory
                      reelVideosWireframe:(id<RTVideoWireframe>)reelVideosWireframe
                         thumbnailSupport:(RTThumbnailSupport *)thumbnailSupport;

@end
