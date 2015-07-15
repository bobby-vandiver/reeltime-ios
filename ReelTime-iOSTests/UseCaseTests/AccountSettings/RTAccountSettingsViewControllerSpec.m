#import "RTTestCommon.h"

#import "RTAccountSettingsViewController.h"
#import "RTAccountSettingsPresenter.h"

SpecBegin(RTAccountSettingsViewController)

describe(@"account settings view controller", ^{
    
    __block RTAccountSettingsViewController *viewController;
    __block RTAccountSettingsPresenter *presenter;
    
    __block UITableView *tableView;
    
    beforeEach(^{
        presenter = mock([RTAccountSettingsPresenter class]);
        viewController = [RTAccountSettingsViewController viewControllerWithPresenter:presenter];
        
        tableView = mock([UITableView class]);
        viewController.tableView = tableView;
    });
    
    describe(@"present detail menu when row is selected", ^{
        it(@"change password", ^{
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];

            [viewController tableView:tableView didSelectRowAtIndexPath:path];
            [verify(presenter) requestedPasswordChange];
        });
        
        it(@"change display name", ^{
            NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
            
            [viewController tableView:tableView didSelectRowAtIndexPath:path];
            [verify(presenter) requestedDisplayNameChange];
        });
        
        it(@"confirm account", ^{
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
            
            [viewController tableView:tableView didSelectRowAtIndexPath:path];
            [verify(presenter) requestedAccountConfirmation];
        });
        
        it(@"manage devices", ^{
            NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:1];
            
            [viewController tableView:tableView didSelectRowAtIndexPath:path];
            [verify(presenter) requestedDeviceManagement];
        });
        
        it(@"logout", ^{
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:2];
            
            [viewController tableView:tableView didSelectRowAtIndexPath:path];
            [verify(presenter) requestedLogout];
        });
    });
});

SpecEnd