#import "RTAccountSettingsViewController.h"
#import "RTAccountSettingsPresenter.h"

#import "RTStoryboardViewControllerFactory.h"

static const NSInteger ChangePasswordSection = 0;
static const NSInteger ChangePasswordRow = 0;

static const NSInteger ChangeDisplayNameSection = 0;
static const NSInteger ChangeDisplayNameRow = 1;

static const NSInteger ConfirmAccountSection = 1;
static const NSInteger ConfirmAccountRow = 0;

static const NSInteger ManageDevicesSection = 1;
static const NSInteger ManageDevicesRow = 1;

@interface RTAccountSettingsViewController ()

@property RTAccountSettingsPresenter *presenter;

@end

@implementation RTAccountSettingsViewController

+ (instancetype)viewControllerWithPresenter:(RTAccountSettingsPresenter *)presenter {
    NSString *identifier = [RTAccountSettingsViewController storyboardIdentifier];
    RTAccountSettingsViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.presenter = presenter;
    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Account Settings View Controller";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == ChangePasswordSection && row == ChangePasswordRow) {
        [self.presenter requestedPasswordChange];
    }
    else if (section == ChangeDisplayNameSection && row == ChangeDisplayNameRow) {
        [self.presenter requestedDisplayNameChange];
    }
    else if (section == ConfirmAccountSection && row == ConfirmAccountRow) {
        [self.presenter requestedAccountConfirmation];
    }
    else if (section == ManageDevicesSection && row == ManageDevicesRow) {
        [self.presenter requestedDeviceManagement];
    }
}

@end
