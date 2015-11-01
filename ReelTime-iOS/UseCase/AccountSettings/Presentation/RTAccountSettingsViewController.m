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

static const NSInteger LogoutSection = 2;
static const NSInteger LogoutRow = 0;

@interface RTAccountSettingsViewController ()

@property RTAccountSettingsPresenter *presenter;

@end

@implementation RTAccountSettingsViewController

+ (instancetype)viewControllerWithPresenter:(RTAccountSettingsPresenter *)presenter {
    RTAccountSettingsViewController *controller = [RTStoryboardViewControllerFactory storyboardViewController:self];
    
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
    else if (section == LogoutSection && row == LogoutRow) {
        [self.presenter requestedLogout];
    }
}

- (void)showErrorMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
