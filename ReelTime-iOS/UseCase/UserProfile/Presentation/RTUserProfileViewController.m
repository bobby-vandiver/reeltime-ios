#import "RTUserProfileViewController.h"

#import "RTUserSummaryPresenter.h"
#import "RTBrowseReelsPresenter.h"

#import "RTBrowseReelVideosPresenterFactory.h"
#import "RTThumbnailSupport.h"

#import "RTArrayDataSource.h"
#import "RTMutableArrayDataSource.h"

#import "RTStoryboardViewControllerFactory.h"

#import "RTUserDescription.h"

#import "RTUserProfileAssembly.h"
#import "RTBrowseVideosPresenter.h"

#import "RTUserReelCell.h"
#import "RTReelDescription.h"

#import "RTLogging.h"

static NSString *const UserReelCellIdentifier = @"UserReelCell";

@interface RTUserProfileViewController ()

@property (copy) NSString *username;
@property RTUserSummaryPresenter *userPresenter;

@property RTBrowseReelsPresenter *reelsPresenter;
@property RTMutableArrayDataSource *reelsDataSource;

@property id<RTBrowseReelVideosPresenterFactory> reelVideosPresenterFactory;
@property id<RTVideoWireframe> reelVideosWireframe;

@property RTThumbnailSupport *thumbnailSupport;

@end

@implementation RTUserProfileViewController

+ (instancetype)viewControllerForUsername:(NSString *)username
                        withUserPresenter:(RTUserSummaryPresenter *)userPresenter
                           reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter
               reelVideosPresenterFactory:(id<RTBrowseReelVideosPresenterFactory>)reelVideosPresenterFactory
                      reelVideosWireframe:(id<RTVideoWireframe>)reelVideosWireframe
                         thumbnailSupport:(RTThumbnailSupport *)thumbnailSupport {

    NSString *identifier = [RTUserProfileViewController storyboardIdentifier];
    RTUserProfileViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.username = username;
        controller.userPresenter = userPresenter;
        controller.reelsPresenter = reelsPresenter;
        controller.reelVideosPresenterFactory = reelVideosPresenterFactory;
        controller.reelVideosWireframe = reelVideosWireframe;
        controller.thumbnailSupport = thumbnailSupport;
    }
    
    [controller createDataSource];
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.userPresenter requestedSummaryForUsername:self.username];
    [self.reelsPresenter requestedNextPage];
}

- (UITableView *)tableView {
    return self.reelsListTableView;
}

- (RTPagedListPresenter *)presenter {
    return self.reelsPresenter;
}

- (IBAction)pressedSettingsButton {
    DDLogDebug(@"pressed settings button!");
}


- (void)showUserDescription:(RTUserDescription *)description {
    self.usernameLabel.text = [NSString stringWithFormat:@"Username: %@", description.username];
    self.displayNameLabel.text = [NSString stringWithFormat:@"Display name: %@", description.displayName];
    
    self.subscribersLabel.text = [NSString stringWithFormat:@"Subscribers: %@", description.numberOfFollowers];
    self.subscribedToLabel.text = [NSString stringWithFormat:@"Subscribed to: %@", description.numberOfFollowees];
    
    self.reelsCreatedLabel.text = [NSString stringWithFormat:@"Reels Created: %@", description.numberOfReelsOwned];
    self.reelsFollowingLabel.text = [NSString stringWithFormat:@"Reels Following: %@", description.numberOfAudienceMemberships];
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
    
    UILabel *label = [[UILabel alloc] init];
    label.text = description.name;
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.thumbnailSupport.dimensions.height;
}

@end
