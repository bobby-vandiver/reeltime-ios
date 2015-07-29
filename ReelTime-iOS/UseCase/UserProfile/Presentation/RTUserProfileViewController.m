#import "RTUserProfileViewController.h"
#import "RTUserProfilePresenter.h"

#import "RTUserSummaryPresenter.h"
#import "RTBrowseReelsPresenter.h"

#import "RTFollowUserPresenter.h"
#import "RTUnfollowUserPresenter.h"

#import "RTJoinAudiencePresenter.h"
#import "RTLeaveAudiencePresenter.h"

#import "RTBrowseReelVideosPresenterFactory.h"

#import "RTThumbnailSupport.h"
#import "RTCurrentUserService.h"

#import "RTArrayDataSource.h"
#import "RTMutableArrayDataSource.h"

#import "RTStoryboardViewControllerFactory.h"

#import "RTUserDescription.h"
#import "RTBrowseVideosPresenter.h"

#import "RTUserReelHeaderView.h"
#import "RTUserReelFooterView.h"

#import "RTUserReelCell.h"
#import "RTReelDescription.h"

#import "RTLogging.h"

static NSString *const UserReelHeaderNibName = @"RTUserReelHeaderView";
static NSString *const UserReelFooterNibName = @"RTUserReelFooterView";

static NSString *const UserReelHeaderIdentifier = @"UserReelHeader";
static NSString *const UserReelFooterIdentifier = @"UserReelFooter";

static NSString *const UserReelCellIdentifier = @"UserReelCell";

@interface RTUserProfileViewController ()

@property (copy) NSString *username;

@property RTUserProfilePresenter *userProfilePresenter;
@property RTUserSummaryPresenter *userSummaryPresenter;

@property RTBrowseReelsPresenter *reelsPresenter;
@property RTMutableArrayDataSource *reelsDataSource;

@property id<RTBrowseReelVideosPresenterFactory> reelVideosPresenterFactory;
@property id<RTVideoWireframe> reelVideosWireframe;

@property RTFollowUserPresenter *followUserPresenter;
@property RTUnfollowUserPresenter *unfollowUserPresenter;

@property RTJoinAudiencePresenter *joinAudiencePresenter;
@property RTLeaveAudiencePresenter *leaveAudiencePresenter;

@property RTThumbnailSupport *thumbnailSupport;
@property RTCurrentUserService *currentUserService;

@property BOOL profileIsForCurrentUser;
@property BOOL currentUserIsFollowing;

@property NSNumber *numberOfFollowers;

@end

@implementation RTUserProfileViewController

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
                       currentUserService:(RTCurrentUserService *)currentUserService {

    NSString *identifier = [RTUserProfileViewController storyboardIdentifier];
    RTUserProfileViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.username = username;
        controller.userProfilePresenter = userProfilePresenter;
        controller.userSummaryPresenter = userSummaryPresenter;
        controller.reelsPresenter = reelsPresenter;
        controller.followUserPresenter = followUserPresenter;
        controller.unfollowUserPresenter = unfollowUserPresenter;
        controller.joinAudiencePresenter = joinAudiencePresenter;
        controller.leaveAudiencePresenter = leaveAudiencePresenter;
        controller.reelVideosPresenterFactory = reelVideosPresenterFactory;
        controller.reelVideosWireframe = reelVideosWireframe;
        controller.thumbnailSupport = thumbnailSupport;
        controller.currentUserService = currentUserService;
        [controller createDataSource];
    }
    
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"User Profile View Controller";
}

- (void)createDataSource {
    ConfigureCellBlock configBlock = ^(RTUserReelCell *cell, RTReelDescription *description) {
        RTBrowseVideosPresenter *videosPresenter =
            [self.reelVideosPresenterFactory browseReelVideosPresenterForReelId:description.reelId
                                                                       username:self.username
                                                                           view:cell
                                                                      wireframe:self.reelVideosWireframe];
        [cell configureWithVideosPresenter:videosPresenter];
    };
    
    self.reelsDataSource = [RTMutableArrayDataSource sectionMajorArrayWithItems:@[]
                                                                 cellIdentifier:UserReelCellIdentifier
                                                             configureCellBlock:configBlock];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDataSource:self.reelsDataSource];
    [self.tableView setDelegate:self];

    UINib *sectionHeaderNib = [UINib nibWithNibName:UserReelHeaderNibName bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:UserReelHeaderIdentifier];
    
    UINib *sectionFooterNib = [UINib nibWithNibName:UserReelFooterNibName bundle:nil];
    [self.tableView registerNib:sectionFooterNib forHeaderFooterViewReuseIdentifier:UserReelFooterIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.userSummaryPresenter requestedSummaryForUsername:self.username];
    [self.reelsPresenter requestedNextPage];
}

- (UITableView *)tableView {
    return self.reelsListTableView;
}

- (RTPagedListPresenter *)presenter {
    return self.reelsPresenter;
}

- (BOOL)currentUserHasUsername:(NSString *)username {
    NSString *currentUsername = [self.currentUserService currentUsername];
    return [currentUsername isEqual:username];
}

- (IBAction)pressedSettingsOrFollowUserButton {
    if (self.profileIsForCurrentUser) {
        [self.userProfilePresenter requestedAccountSettings];
    }
    else {
        if (self.currentUserIsFollowing) {
            [self.unfollowUserPresenter requestedUserUnfollowingForUsername:self.username];
        }
        else {
            [self.followUserPresenter requestedUserFollowingForUsername:self.username];
        }
    }
}

- (IBAction)pressedSubscribersButton {
}

- (IBAction)pressedSubscribedToButton {
}

- (void)showUserDescription:(RTUserDescription *)description {
    self.profileIsForCurrentUser = [self currentUserHasUsername:description.username];

    if (self.profileIsForCurrentUser) {
        [self.settingsOrFollowUserButton setTitle:@"Settings" forState:UIControlStateNormal];
    }
    else {
        self.currentUserIsFollowing = [description.currentUserIsFollowing boolValue];
        [self updateFollowUserButton];
    }

    self.usernameLabel.text = [NSString stringWithFormat:@"Username: %@", description.username];
    self.displayNameLabel.text = [NSString stringWithFormat:@"Display name: %@", description.displayName];
    
    self.numberOfFollowers = description.numberOfFollowers;
    [self updateSubscribersButton];
    
    NSString *subscribedToText = [NSString stringWithFormat:@"Subscribed to: %@", description.numberOfFollowees];
    [self.subscribedToButton setTitle:subscribedToText forState:UIControlStateNormal];
    
    self.reelsCreatedLabel.text = [NSString stringWithFormat:@"Reels Created: %@", description.numberOfReelsOwned];
    self.reelsFollowingLabel.text = [NSString stringWithFormat:@"Reels Following: %@", description.numberOfAudienceMemberships];
}

- (void)updateFollowUserButton {
    NSString *title = self.currentUserIsFollowing ? @"Unfollow" : @"Follow";
    [self.settingsOrFollowUserButton setTitle:title forState:UIControlStateNormal];
}

- (void)updateSubscribersButton {
    NSString *subscribersText = [NSString stringWithFormat:@"Subscribers: %@", self.numberOfFollowers];
    [self.subscribersButton setTitle:subscribersText forState:UIControlStateNormal];
}

- (void)incrementNumberOfFollowers {
    self.numberOfFollowers = [NSNumber numberWithInteger:[self.numberOfFollowers integerValue] + 1];
}

- (void)decrementNumberOfFollowers {
    self.numberOfFollowers = [NSNumber numberWithInteger:[self.numberOfFollowers integerValue] - 1];
}

- (void)showUserNotFoundMessage:(NSString *)message {
    [self showErrorMessage:message];
}

- (void)showReelDescription:(RTReelDescription *)description {
    [self.reelsDataSource addItem:description];
    [self.tableView reloadData];
}

- (void)clearReelDescriptions {
    [self.reelsDataSource removeAllItems];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate Methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    RTReelDescription *description = [self.reelsDataSource itemAtIndex:section];
    RTUserReelHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:UserReelHeaderIdentifier];
    
    BOOL hasZeroOrMoreThanOneVideo = ![description.numberOfVideos isEqualToNumber:@(1)];

    header.reelNameLabel.text = description.name;
    header.videoCountLabel.text = [NSString stringWithFormat:@"%@ Video%@", description.numberOfVideos,
                                   (hasZeroOrMoreThanOneVideo ? @"s" : @"")];

    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    RTReelDescription *description = [self.reelsDataSource itemAtIndex:section];
    RTUserReelFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:UserReelFooterIdentifier];
    
    footer.delegate = self;
    footer.reelId = description.reelId;

    BOOL currentUserIsAudienceMember = [description.currentUserIsAnAudienceMember boolValue];
    BOOL hasZeroOrMoreThanOneMember = ![description.audienceSize isEqualToNumber:@(1)];
    
    NSString *followReelTitle = currentUserIsAudienceMember ? @"Unfollow Reel" : @"Follow Reel";
    
    NSString *listAudienceTitle = [NSString stringWithFormat:@"%@ Follower%@", description.audienceSize,
                                   (hasZeroOrMoreThanOneMember ? @"s" : @"")];

    [footer.followReelButton setTitle:followReelTitle forState:UIControlStateNormal];
    [footer.listAudienceButton setTitle:listAudienceTitle forState:UIControlStateNormal];
    
    BOOL profileIsForCurrentUser = [self currentUserHasUsername:description.ownerUsername];
    footer.followReelButton.hidden = profileIsForCurrentUser;
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.thumbnailSupport.dimensions.height;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark - RTUserReelFooterViewDelegate Methods

- (void)footerView:(RTUserReelFooterView *)footerView didPressFollowReelButton:(UIButton *)button forReelId:(NSNumber *)reelId {
    RTReelDescription *description = [self reelDescriptionForReelId:reelId];
    
    if ([description.currentUserIsAnAudienceMember boolValue]) {
        [self.leaveAudiencePresenter requestedAudienceMembershipLeaveForReelId:reelId];
    }
    else {
        [self.joinAudiencePresenter requestedAudienceMembershipForReelId:reelId];
    }
}

- (void)footerView:(RTUserReelFooterView *)footerView didPressListAudienceButton:(UIButton *)button forReelId:(NSNumber *)reelId {
    [self.userProfilePresenter requestedAudienceMembersForReelId:reelId];
}

#pragma mark - RTErrorMessageView Methods

- (void)showErrorMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - RTFollowUserView Methods

- (void)showUserAsFollowedForUsername:(NSString *)username {
    self.currentUserIsFollowing = YES;
    [self updateFollowUserButton];
    
    [self incrementNumberOfFollowers];
    [self updateSubscribersButton];
}

#pragma mark - RTUnfollowUserView Methods

- (void)showUserAsUnfollowedForUsername:(NSString *)username {
    self.currentUserIsFollowing = NO;
    [self updateFollowUserButton];
    
    [self decrementNumberOfFollowers];
    [self updateSubscribersButton];
}

#pragma mark - RTJoinAudienceView Methods

- (void)showAudienceAsJoinedForReelId:(NSNumber *)reelId {
    RTReelDescription *description = [self reelDescriptionForReelId:reelId];
    
    [description currentUserJoinedAudience];
    [self.tableView reloadData];
}

#pragma mark - RTLeaveAudienceView Methods

- (void)showAudienceAsNotJoinedForReelId:(NSNumber *)reelId {
    RTReelDescription *description = [self reelDescriptionForReelId:reelId];

    [description currentUserLeftAudience];
    [self.tableView reloadData];
}

- (RTReelDescription *)reelDescriptionForReelId:(NSNumber *)reelId {
    return [self.reelsDataSource itemPassingTest:^BOOL(RTReelDescription *item) {
        return [item.reelId isEqual:reelId];
    }];
}

@end
