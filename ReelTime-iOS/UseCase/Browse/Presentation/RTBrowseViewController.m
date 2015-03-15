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

+ (NSString *)storyboardIdentifier {
    return @"Browse View Controller";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self useUsersDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.usersPresenter requestedNextPage];
    [self.reelsPresenter requestedNextPage];
    [self.videosPresenter requestedNextPage];
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

- (void)useUsersDataSource {
    [self useDataSource:self.usersDataSource ofType:UsersDataSource];
}

- (void)useReelsDataSource {
    [self useDataSource:self.reelsDataSource ofType:ReelsDataSource];
}

- (void)useVideosDataSource {
    [self useDataSource:self.videosDataSource ofType:VideosDataSource];
}

- (void)showUserMessage:(RTUserMessage *)message {
    [self addItem:message toDataSource:self.usersDataSource ofType:UsersDataSource];
}

- (void)clearUserMessages {
    [self removeAllItemsFromDataSource:self.usersDataSource ofType:UsersDataSource];
}

- (void)showReelMessage:(RTReelMessage *)message {
    [self addItem:message toDataSource:self.reelsDataSource ofType:ReelsDataSource];
}

- (void)clearReelMessages {
    [self removeAllItemsFromDataSource:self.reelsDataSource ofType:ReelsDataSource];
}

- (void)showVideoMessage:(RTVideoMessage *)message {
    [self addItem:message toDataSource:self.videosDataSource ofType:VideosDataSource];
}

- (void)clearVideoMessages {
    [self removeAllItemsFromDataSource:self.videosDataSource ofType:VideosDataSource];
}

- (void)useDataSource:(RTMutableArrayDataSource *)dataSource
               ofType:(DataSourceType)type {
    self.currentDataSourceType = type;
    
    [self.tableView setDataSource:dataSource];
    [self.tableView reloadData];
}

- (void)addItem:(id)item
   toDataSource:(RTMutableArrayDataSource *)dataSource
         ofType:(DataSourceType)type {
    [dataSource addItem:item];
    [self reloadTableViewIfDataSourceType:type];
}

- (void)removeAllItemsFromDataSource:(RTMutableArrayDataSource *)dataSource
                              ofType:(DataSourceType)type {
    [dataSource removeAllItems];
    [self reloadTableViewIfDataSourceType:type];
}

- (void)reloadTableViewIfDataSourceType:(DataSourceType)dataSourceType {
    if (self.currentDataSourceType == dataSourceType) {
        [self.tableView reloadData];
    }
}

@end
