#import "RTManageDevicesViewController.h"
#import "RTManageDevicesPresenter.h"

#import "RTArrayDataSource.h"
#import "RTMutableArrayDataSource.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTClientDescription.h"

#import "RTLogging.h"

@interface RTManageDevicesViewController ()

@property RTManageDevicesPresenter *devicesPresenter;
@property RTMutableArrayDataSource *dataSource;

@end

@implementation RTManageDevicesViewController

+ (instancetype)viewControllerWithPresenter:(RTManageDevicesPresenter *)presenter {
    NSString *identifier = [RTManageDevicesViewController storyboardIdentifier];
    RTManageDevicesViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.devicesPresenter = presenter;
    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Manage Devices View Controller";
}

- (UITableView *)tableView {
    return self.clientListTableView;
}

- (RTPagedListPresenter *)presenter {
    return self.devicesPresenter;
}

- (void)showErrorMessage:(NSString *)message {
    
}

- (void)showClientDescription:(RTClientDescription *)description {
    
}

- (void)clearClientDescriptions {
    
}

- (void)clearClientDescriptionForClientId:(NSString *)clientId {
    
}

@end
