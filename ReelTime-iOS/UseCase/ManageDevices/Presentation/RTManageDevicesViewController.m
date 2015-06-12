#import "RTManageDevicesViewController.h"
#import "RTManageDevicesPresenter.h"

#import "RTArrayDataSource.h"
#import "RTMutableArrayDataSource.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTClientDescription.h"

#import "RTLogging.h"

static NSString *const DeviceCellIdentifier = @"DeviceCell";

@interface RTManageDevicesViewController ()

@property RTManageDevicesPresenter *devicesPresenter;
@property RTMutableArrayDataSource *devicesDataSource;

@end

@implementation RTManageDevicesViewController

+ (instancetype)viewControllerWithPresenter:(RTManageDevicesPresenter *)presenter {
    NSString *identifier = [RTManageDevicesViewController storyboardIdentifier];
    RTManageDevicesViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.devicesPresenter = presenter;
        controller.devicesDataSource = [self createDataSource];
    }
    return controller;
}

+ (RTMutableArrayDataSource *)createDataSource {
    
    ConfigureCellBlock configureCellBlock = ^(UITableViewCell *cell, RTClientDescription *description) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ :: %@", description.clientId, description.clientName];
    };
    
    return [RTMutableArrayDataSource rowMajorArrayWithItems:@[]
                                             cellIdentifier:DeviceCellIdentifier
                                         configureCellBlock:configureCellBlock];
}

+ (NSString *)storyboardIdentifier {
    return @"Manage Devices View Controller";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setAllowsMultipleSelectionDuringEditing:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.presenter requestedNextPage];
}

- (UITableView *)tableView {
    return self.clientListTableView;
}

- (RTPagedListPresenter *)presenter {
    return self.devicesPresenter;
}

- (void)showErrorMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)showClientDescription:(RTClientDescription *)description {
    [self.devicesDataSource addItem:description];
    [self.tableView reloadData];
}

- (void)clearClientDescriptions {
    [self.devicesDataSource removeAllItems];
    [self.tableView reloadData];
}

- (void)clearClientDescriptionForClientId:(NSString *)clientId {
    MatchItemTest matchTest = [self matchTestForClientDescriptionByClientId:clientId];
    [self.devicesDataSource removeItemsPassingTest:matchTest];
    [self.tableView reloadData];
}

- (MatchItemTest)matchTestForClientDescriptionByClientId:(NSString *)clientId {
    return ^BOOL(RTClientDescription *description) {
        return [description.clientId isEqual:clientId];
    };
}

@end
