#import "RTPagedListViewController.h"
#import "RTUserReelFooterViewDelegate.h"

#import "RTUserSummaryView.h"
#import "RTBrowseReelsView.h"

#import "RTJoinAudienceView.h"
#import "RTLeaveAudienceView.h"

#import "RTStoryboardViewController.h"

@class RTUserProfilePresenter;

@class RTUserSummaryPresenter;
@class RTBrowseReelsPresenter;

@class RTJoinAudiencePresenter;
@class RTLeaveAudiencePresenter;

@class RTThumbnailSupport;
@class RTCurrentUserService;

@protocol RTBrowseReelVideosPresenterFactory;
@protocol RTVideoWireframe;

@interface RTUserProfileViewController : RTPagedListViewController <RTUserSummaryView, RTBrowseReelsView, RTJoinAudienceView, RTLeaveAudienceView, RTUserReelFooterViewDelegate, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *subscribersLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscribedToLabel;

@property (weak, nonatomic) IBOutlet UILabel *reelsCreatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *reelsFollowingLabel;

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UITableView *reelsListTableView;

+ (instancetype)viewControllerForUsername:(NSString *)username
                 withUserProfilePresenter:(RTUserProfilePresenter *)userProfilePresenter
                     userSummaryPresenter:(RTUserSummaryPresenter *)userSummaryPresenter
                           reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter
                    joinAudiencePresenter:(RTJoinAudiencePresenter *)joinAudiencePresenter
                   leaveAudiencePresenter:(RTLeaveAudiencePresenter *)leaveAudiencePresenter
               reelVideosPresenterFactory:(id<RTBrowseReelVideosPresenterFactory>)reelVideosPresenterFactory
                      reelVideosWireframe:(id<RTVideoWireframe>)reelVideosWireframe
                         thumbnailSupport:(RTThumbnailSupport *)thumbnailSupport
                       currentUserService:(RTCurrentUserService *)currentUserService;

- (IBAction)pressedSettingsButton;

@end
