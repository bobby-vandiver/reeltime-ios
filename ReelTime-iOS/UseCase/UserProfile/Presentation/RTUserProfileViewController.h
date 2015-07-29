#import "RTPagedListViewController.h"
#import "RTUserReelFooterViewDelegate.h"

#import "RTUserSummaryView.h"
#import "RTBrowseReelsView.h"

#import "RTFollowUserView.h"
#import "RTUnfollowUserView.h"

#import "RTJoinAudienceView.h"
#import "RTLeaveAudienceView.h"

#import "RTStoryboardViewController.h"

@class RTUserProfilePresenter;

@class RTUserSummaryPresenter;
@class RTBrowseReelsPresenter;

@class RTFollowUserPresenter;
@class RTUnfollowUserPresenter;

@class RTJoinAudiencePresenter;
@class RTLeaveAudiencePresenter;

@class RTThumbnailSupport;
@class RTCurrentUserService;

@protocol RTBrowseReelVideosPresenterFactory;
@protocol RTVideoWireframe;

@interface RTUserProfileViewController : RTPagedListViewController <RTUserSummaryView, RTBrowseReelsView, RTFollowUserView, RTUnfollowUserView, RTJoinAudienceView, RTLeaveAudienceView, RTUserReelFooterViewDelegate, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *subscribersButton;
@property (weak, nonatomic) IBOutlet UIButton *subscribedToButton;

@property (weak, nonatomic) IBOutlet UILabel *reelsCreatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *reelsFollowingLabel;

@property (weak, nonatomic) IBOutlet UIButton *settingsOrFollowUserButton;
@property (weak, nonatomic) IBOutlet UITableView *reelsListTableView;

+ (instancetype)viewControllerForUsername:(NSString *)username
                 withUserProfilePresenter:(RTUserProfilePresenter *)userProfilePresenter
                     userSummaryPresenter:(RTUserSummaryPresenter *)userSummaryPresenter
                           reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter
                      followUserPresenter:(RTFollowUserPresenter *)followUserPresenter
                    unfollowUserPresenter:(RTUnfollowUserPresenter *)unfollowUserPresenter
                    joinAudiencePresenter:(RTJoinAudiencePresenter *)joinAudiencePresenter
                   leaveAudiencePresenter:(RTLeaveAudiencePresenter *)leaveAudiencePresenter
               reelVideosPresenterFactory:(id<RTBrowseReelVideosPresenterFactory>)reelVideosPresenterFactory
                      reelVideosWireframe:(id<RTVideoWireframe>)reelVideosWireframe
                         thumbnailSupport:(RTThumbnailSupport *)thumbnailSupport
                       currentUserService:(RTCurrentUserService *)currentUserService;

- (IBAction)pressedSettingsOrFollowUserButton;

- (IBAction)pressedSubscribersButton;

- (IBAction)pressedSubscribedToButton;

@end
