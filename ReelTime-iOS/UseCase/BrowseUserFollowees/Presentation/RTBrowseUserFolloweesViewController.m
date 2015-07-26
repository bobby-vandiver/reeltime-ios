#import "RTBrowseUserFolloweesViewController.h"
#import "RTBrowseUsersPresenter.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTMutableArrayDataSource.h"

#import "RTUserFolloweeCell.h"
#import "RTUserDescription.h"

static NSString *const UserFolloweeCellIdentifier = @"UserFolloweeCell";

@interface RTBrowseUserFolloweesViewController ()

@property RTBrowseUsersPresenter *usersPresenter;
@property RTMutableArrayDataSource *userFolloweesDataSource;

@end

@implementation RTBrowseUserFolloweesViewController

+ (instancetype)viewControllerWithUsersPresenter:(RTBrowseUsersPresenter *)usersPresenter {
    
    NSString *identifier = [RTBrowseUserFolloweesViewController storyboardIdentifier];
    RTBrowseUserFolloweesViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.usersPresenter = usersPresenter;
        [controller createDataSource];
    }
    
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return  @"Browse User Followees View Controller";
}

- (void)createDataSource {
    ConfigureCellBlock configBlock = ^(RTUserFolloweeCell *cell, RTUserDescription *description) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", description.displayName];
    };
    
    self.userFolloweesDataSource = [RTMutableArrayDataSource rowMajorArrayWithItems:@[]
                                                                     cellIdentifier:UserFolloweeCellIdentifier
                                                                 configureCellBlock:configBlock];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setDataSource:self.userFolloweesDataSource];
    [self.tableView setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.presenter requestedNextPage];
}

- (UITableView *)tableView {
    return self.browseUserFolloweesTableView;
}

- (RTPagedListPresenter *)presenter {
    return self.usersPresenter;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    RTUserDescription *description = self.userFolloweesDataSource.items[row];
    [self.usersPresenter requestedUserDetailsForUsername:description.username];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)showUserDescription:(RTUserDescription *)description {
    [self.userFolloweesDataSource addItem:description];
    [self.tableView reloadData];
}

- (void)clearUserDescriptions {
    [self.userFolloweesDataSource removeAllItems];
    [self.tableView reloadData];
}

@end
