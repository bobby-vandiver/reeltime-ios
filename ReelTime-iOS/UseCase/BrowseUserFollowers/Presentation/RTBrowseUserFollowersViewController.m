#import "RTBrowseUserFollowersViewController.h"
#import "RTBrowseUsersPresenter.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTMutableArrayDataSource.h"

#import "RTUserFollowerCell.h"
#import "RTUserDescription.h"

static NSString *const UserFollowerCellIdentifier = @"UserFollowerCell";

@interface RTBrowseUserFollowersViewController ()

@property RTBrowseUsersPresenter *usersPresenter;
@property RTMutableArrayDataSource *userFollowersDataSource;

@end

@implementation RTBrowseUserFollowersViewController

+ (instancetype)viewControllerWithUsersPresenter:(RTBrowseUsersPresenter *)usersPresenter {
    
    NSString *identifier = [RTBrowseUserFollowersViewController storyboardIdentifier];
    RTBrowseUserFollowersViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.usersPresenter = usersPresenter;
        [controller createDataSource];
    }
    
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Browse User Followers View Controller";
}

- (void)createDataSource {
    ConfigureCellBlock configBlock = ^(RTUserFollowerCell *cell, RTUserDescription *description) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", description.displayName];
    };
    
    self.userFollowersDataSource = [RTMutableArrayDataSource rowMajorArrayWithItems:@[]
                                                                     cellIdentifier:UserFollowerCellIdentifier
                                                                 configureCellBlock:configBlock];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setDataSource:self.userFollowersDataSource];
    [self.tableView setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.presenter requestedNextPage];
}

- (UITableView *)tableView {
    return self.browseUserFollowersTableView;
}

- (RTPagedListPresenter *)presenter {
    return self.usersPresenter;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    RTUserDescription *description = self.userFollowersDataSource.items[row];
    [self.usersPresenter requestedUserDetailsForUsername:description.username];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)showUserDescription:(RTUserDescription *)description {
    [self.userFollowersDataSource addItem:description];
    [self.tableView reloadData];
}

- (void)clearUserDescriptions {
    [self.userFollowersDataSource removeAllItems];
    [self.tableView reloadData];
}

@end
