#import "RTUserProfileViewController.h"

#import "RTUserSummaryPresenter.h"
#import "RTBrowseReelsPresenter.h"

#import "RTStoryboardViewControllerFactory.h"

@interface RTUserProfileViewController ()

@property RTUserSummaryPresenter *userPresenter;
@property RTBrowseReelsPresenter *reelsPresenter;

@end

@implementation RTUserProfileViewController

+ (RTUserProfileViewController *)viewControllerWithUserPresenter:(RTUserSummaryPresenter *)userPresenter
                                                  reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter {
    NSString *identifier = [RTUserProfileViewController storyboardIdentifier];
    RTUserProfileViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.userPresenter = userPresenter;
        controller.reelsPresenter = reelsPresenter;
    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"User Profile View Controller";
}

- (UITableView *)tableView {
    return self.reelsListTableView;
}

- (RTPagedListPresenter *)presenter {
    return self.reelsPresenter;
}

- (void)showUserDescription:(RTUserDescription *)description {
    
}

- (void)showUserNotFoundMessage:(NSString *)message {
    
}

- (void)showReelDescription:(RTReelDescription *)description {
    
}

- (void)clearReelDescriptions {
    
}

@end
