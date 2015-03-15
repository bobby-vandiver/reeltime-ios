#import "RTBrowseViewController.h"

#import "RTBrowseUsersPresenter.h"
#import "RTBrowseReelsPresenter.h"
#import "RTBrowseVideosPresenter.h"

#import "RTArrayDataSource.h"
#import "RTMutableArrayDataSource.h"

#import "RTBrowseViewDataSourceFactory.h"
#import "RTStoryboardViewControllerFactory.h"

#import "RTLogging.h"

typedef enum {
    UsersDataSource,
    ReelsDataSource,
    VideosDataSource
} DataSourceType;

@interface RTBrowseViewController ()

@property RTBrowseUsersPresenter *usersPresenter;
@property RTBrowseReelsPresenter *reelsPresenter;
@property RTBrowseVideosPresenter *videosPresenter;

@property DataSourceType currentDataSourceType;

@property RTMutableArrayDataSource *usersDataSource;
@property RTMutableArrayDataSource *reelsDataSource;
@property RTMutableArrayDataSource *videosDataSource;

@end

@implementation RTBrowseViewController

+ (RTBrowseViewController *)viewControllerWithUsersPresenter:(RTBrowseUsersPresenter *)usersPresenter
                                              reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter
                                             videosPresenter:(RTBrowseVideosPresenter *)videosPresenter {
    NSString *identifier = [RTBrowseViewController storyboardIdentifier];
    RTBrowseViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.usersPresenter = usersPresenter;
        controller.reelsPresenter = reelsPresenter;
        controller.videosPresenter = videosPresenter;
        
        controller.usersDataSource = [RTBrowseViewDataSourceFactory usersDataSource];
        controller.reelsDataSource = [RTBrowseViewDataSourceFactory reelsDataSource];
        controller.videosDataSource = [RTBrowseViewDataSourceFactory videosDataSource];
    }
    return controller;
}

- (IBAction)segmentedControlChanged {
    NSInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
    
    if (selectedIndex == UsersDataSource) {
        [self useUsersDataSource];
    }
    else if (selectedIndex == ReelsDataSource) {
        [self useReelsDataSource];
    }
    else if (selectedIndex == VideosDataSource) {
        [self useVideosDataSource];
    }
    else {
        DDLogError(@"Received unknown segment index: %ld", (long)selectedIndex);
    }
}

+ (NSString *)storyboardIdentifier {
    return @"Browse View Controller";
}

- (void)useUsersDataSource {
    self.currentDataSourceType = UsersDataSource;
    self.tableView.dataSource = self.usersDataSource;
}

- (void)useReelsDataSource {
    self.currentDataSourceType = ReelsDataSource;
    self.tableView.dataSource = self.reelsDataSource;
}

- (void)useVideosDataSource {
    self.currentDataSourceType = VideosDataSource;
    self.tableView.dataSource = self.videosDataSource;
}

- (void)reloadTableViewIfDataSourceType:(DataSourceType)dataSourceType {
    if (self.currentDataSourceType == dataSourceType) {
        [self.tableView reloadData];
    }
}

- (void)showUserMessage:(RTUserMessage *)message {
    [self.usersDataSource addItem:message];
    [self reloadTableViewIfDataSourceType:UsersDataSource];
}

- (void)clearUserMessages {
    [self.usersDataSource removeAllItems];
    [self reloadTableViewIfDataSourceType:UsersDataSource];
}

- (void)showReelMessage:(RTReelMessage *)message {
    [self.reelsDataSource addItem:message];
    [self reloadTableViewIfDataSourceType:ReelsDataSource];
}

- (void)clearReelMessages {
    [self.reelsDataSource removeAllItems];
    [self reloadTableViewIfDataSourceType:ReelsDataSource];
}

- (void)showVideoMessage:(RTVideoMessage *)message {
    [self.videosDataSource addItem:message];
    [self reloadTableViewIfDataSourceType:VideosDataSource];
}

- (void)clearVideoMessages {
    [self.videosDataSource removeAllItems];
    [self reloadTableViewIfDataSourceType:VideosDataSource];
}

@end
