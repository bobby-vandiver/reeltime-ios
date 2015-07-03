#import "RTUserProfileViewController.h"
#import "RTUserProfilePresenter.h"

#import "RTUserSummaryPresenter.h"
#import "RTBrowseReelsPresenter.h"

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

@property RTThumbnailSupport *thumbnailSupport;
@property RTCurrentUserService *currentUserService;

@end

@implementation RTUserProfileViewController

+ (instancetype)viewControllerForUsername:(NSString *)username
                 withUserProfilePresenter:(RTUserProfilePresenter *)userProfilePresenter
                     userSummaryPresenter:(RTUserSummaryPresenter *)userSummaryPresenter
                           reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter
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
        RTBrowseVideosPresenter *videosPresenter = [self.reelVideosPresenterFactory browseReelVideosPresenterForReelId:description.reelId
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

- (IBAction)pressedSettingsButton {
    [self.userProfilePresenter requestedAccountSettings];
}

- (void)showUserDescription:(RTUserDescription *)description {
    [self setSettingsButtonVisibilityForUsername:description.username];

    self.usernameLabel.text = [NSString stringWithFormat:@"Username: %@", description.username];
    self.displayNameLabel.text = [NSString stringWithFormat:@"Display name: %@", description.displayName];
    
    self.subscribersLabel.text = [NSString stringWithFormat:@"Subscribers: %@", description.numberOfFollowers];
    self.subscribedToLabel.text = [NSString stringWithFormat:@"Subscribed to: %@", description.numberOfFollowees];
    
    self.reelsCreatedLabel.text = [NSString stringWithFormat:@"Reels Created: %@", description.numberOfReelsOwned];
    self.reelsFollowingLabel.text = [NSString stringWithFormat:@"Reels Following: %@", description.numberOfAudienceMemberships];
}

- (void)setSettingsButtonVisibilityForUsername:(NSString *)username {
    NSString *currentUsername = [self.currentUserService currentUsername];

    BOOL profileIsForCurrentUser = [currentUsername isEqual:username];
    self.settingsButton.hidden = !profileIsForCurrentUser;
}

- (void)showUserNotFoundMessage:(NSString *)message {
    
}

- (void)showReelDescription:(RTReelDescription *)description {
    [self.reelsDataSource addItem:description];
    [self.tableView reloadData];
}

- (void)clearReelDescriptions {
    [self.reelsDataSource removeAllItems];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate Methods (WIP)

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    RTReelDescription *description = [self.reelsDataSource itemAtIndex:section];
    RTUserReelHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:UserReelHeaderIdentifier];

    header.reelNameLabel.text = description.name;
    header.videoCountLabel.text = [NSString stringWithFormat:@"%@ Videos", description.numberOfVideos];

    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    RTReelDescription *description = [self.reelsDataSource itemAtIndex:section];
    RTUserReelFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:UserReelFooterIdentifier];
    
    NSString *followReelTitle = @"Follow Reel";
    NSString *listAudienceTitle = [NSString stringWithFormat:@"%@ Followers", description.audienceSize];

    [footer.followReelButton setTitle:followReelTitle forState:UIControlStateNormal];
    [footer.listAudienceButton setTitle:listAudienceTitle forState:UIControlStateNormal];
    
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

@end
