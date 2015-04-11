#import "RTUserProfileViewController.h"

#import "RTUserSummaryPresenter.h"
#import "RTBrowseReelsPresenter.h"

#import "RTArrayDataSource.h"
#import "RTMutableArrayDataSource.h"

#import "RTStoryboardViewControllerFactory.h"

@interface RTUserProfileViewController ()

@property (copy) NSString *username;
@property RTUserSummaryPresenter *userPresenter;

@property RTBrowseReelsPresenter *reelsPresenter;
@property RTMutableArrayDataSource *reelsDataSource;

@end

@implementation RTUserProfileViewController

+ (RTUserProfileViewController *)viewControllerForUsername:(NSString *)username
                                         withUserPresenter:(RTUserSummaryPresenter *)userPresenter
                                            reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter {
    NSString *identifier = [RTUserProfileViewController storyboardIdentifier];
    RTUserProfileViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.username = username;
        controller.userPresenter = userPresenter;
        controller.reelsPresenter = reelsPresenter;
        
        // TODO: Create reelsDataSource with config block that kicks off video list retrieval
    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"User Profile View Controller";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDataSource:self.reelsDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.userPresenter requestedSummaryForUsername:self.username];
    [self.reelsPresenter requestedNextPage];
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
