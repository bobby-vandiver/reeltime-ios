#import "RTBrowseAudienceMembersViewController.h"
#import "RTBrowseUsersPresenter.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTMutableArrayDataSource.h"

#import "RTAudienceMemberCell.h"
#import "RTUserDescription.h"

static NSString *const AudienceMemberCellIdentifier = @"AudienceMemberCell";

@interface RTBrowseAudienceMembersViewController ()

@property RTBrowseUsersPresenter *usersPresenter;
@property RTMutableArrayDataSource *audienceMembersDataSource;

@end

@implementation RTBrowseAudienceMembersViewController

+ (instancetype)viewControllerWithUsersPresenter:(RTBrowseUsersPresenter *)usersPresenter {
    NSString *identifier = [RTBrowseAudienceMembersViewController storyboardIdentifier];
    RTBrowseAudienceMembersViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.usersPresenter = usersPresenter;
        [controller createDataSource];
    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Browse Audience Members View Controller";
}

- (void)createDataSource {
    ConfigureCellBlock configBlock = ^(RTAudienceMemberCell *cell, RTUserDescription *description) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                               description.displayName,
                               description.numberOfReelsOwned];
    };
    
    self.audienceMembersDataSource = [RTMutableArrayDataSource rowMajorArrayWithItems:@[]
                                                                       cellIdentifier:AudienceMemberCellIdentifier
                                                                   configureCellBlock:configBlock];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setDataSource:self.audienceMembersDataSource];
    [self.tableView setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.presenter requestedNextPage];
}

- (UITableView *)tableView {
    return self.browseAudienceMembersTableView;
}

- (RTPagedListPresenter *)presenter {
    return self.usersPresenter;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    RTUserDescription *description = self.audienceMembersDataSource.items[row];
    [self.usersPresenter requestedUserDetailsForUsername:description.username];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)showUserDescription:(RTUserDescription *)description {
    [self.audienceMembersDataSource addItem:description];
    [self.tableView reloadData];
}

- (void)clearUserDescriptions {
    [self.audienceMembersDataSource removeAllItems];
    [self.tableView reloadData];
}

@end
