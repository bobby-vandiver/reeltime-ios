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
    RTManageDevicesViewController *controller = [RTStoryboardViewControllerFactory storyboardViewController:self];
    
    if (controller) {
        controller.devicesPresenter = presenter;
        controller.devicesDataSource = [self createDataSourceWithPresenter:presenter];
    }

    return controller;
}

+ (RTMutableArrayDataSource *)createDataSourceWithPresenter:(RTManageDevicesPresenter *)presenter {
    
    ConfigureCellBlock configureCellBlock = ^(UITableViewCell *cell, RTClientDescription *description) {
        cell.textLabel.text = description.clientName;
    };
    
    OnDeleteCellBlock onDeleteCellBlock = ^(UITableViewCell *cell, RTClientDescription *description) {
        [presenter requestedRevocationForClientWithClientId:description.clientId];
    };
    
    return [RTMutableArrayDataSource rowMajorArrayWithItems:@[]
                                             cellIdentifier:DeviceCellIdentifier
                                         configureCellBlock:configureCellBlock
                                          onDeleteCellBlock:onDeleteCellBlock];
}

+ (NSString *)storyboardIdentifier {
    return @"Manage Devices View Controller";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setDataSource:self.devicesDataSource];
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
