#import "RTUserProfileViewController.h"

#import "RTUserSummaryPresenter.h"
#import "RTBrowseReelsPresenter.h"

#import "RTArrayDataSource.h"
#import "RTMutableArrayDataSource.h"

#import "RTStoryboardViewControllerFactory.h"

#import "RTUserDescription.h"

#import "RTUserProfileAssembly.h"
#import "RTBrowseVideosPresenter.h"

#import "RTUserReelTableViewCell.h"
#import "RTReelDescription.h"

#import "RTLogging.h"

@interface RTUserProfileViewController ()

@property (copy) NSString *username;
@property RTUserSummaryPresenter *userPresenter;

@property RTBrowseReelsPresenter *reelsPresenter;
@property RTMutableArrayDataSource *reelsDataSource;

@end

@implementation RTUserProfileViewController

+ (RTUserProfileViewController *)viewControllerForUsername:(NSString *)username
                                         withUserPresenter:(RTUserSummaryPresenter *)userPresenter
                                            reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter {
    NSString *identifier = [RTUserProfileViewController storyboardIdentifier];
    RTUserProfileViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.username = username;
        controller.userPresenter = userPresenter;
        controller.reelsPresenter = reelsPresenter;
    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"User Profile View Controller";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadDataSource];
    [self.tableView setDataSource:self.reelsDataSource];
}

- (void)loadDataSource {
    ConfigureCellBlock configBlock = ^(RTUserReelTableViewCell *cell, RTReelDescription *description) {
        RTBrowseVideosPresenter *videosPresenter = [self.userProfileAssembly browseReelVideosPresenterForReelId:description.reelId
                                                                                                       username:self.username
                                                                                                           view:cell];
        [cell configureWithVideosPresenter:videosPresenter];
    };
    
    self.reelsDataSource = [[RTMutableArrayDataSource alloc] initWithItems:@[]
                                                            cellIdentifier:@"UserReelCell"
                                                        configureCellBlock:configBlock];
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

- (void)showUserDescription:(RTUserDescription *)description {
    DDLogDebug(@"received user description for username = %@", description.username);
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

@end
