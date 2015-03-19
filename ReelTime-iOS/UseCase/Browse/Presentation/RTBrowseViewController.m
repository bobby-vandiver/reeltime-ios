#import "RTBrowseViewController.h"

#import "RTBrowseUsersPresenter.h"
#import "RTBrowseReelsPresenter.h"
#import "RTBrowseVideosPresenter.h"

#import "RTArrayDataSource.h"
#import "RTMutableArrayDataSource.h"

#import "RTBrowseViewDataSourceFactory.h"
#import "RTStoryboardViewControllerFactory.h"

#import "RTUserMessage.h"
#import "RTReelMessage.h"
#import "RTVideoMessage.h"

#import "RTLogging.h"
#import "UITableView+LastVisibleRow.h"

typedef enum {
    BrowseUsersList,
    BrowseReelsList,
    BrowseVideosList
} BrowseListType;

@interface RTBrowseViewController ()

@property BrowseListType currentListType;

@property CGPoint usersListScrollPosition;
@property CGPoint reelsListScrollPosition;
@property CGPoint videosListScrollPosition;

@property RTBrowseUsersPresenter *usersPresenter;
@property RTBrowseReelsPresenter *reelsPresenter;
@property RTBrowseVideosPresenter *videosPresenter;

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
    [self resetSavedScrollPositions];

    [self makeUsersListActive];
    [self.tableView setDelegate:self];
}

- (void)resetSavedScrollPositions {
    CGPoint startingScrollPosition = self.tableView.contentOffset;
    
    self.usersListScrollPosition = startingScrollPosition;
    self.reelsListScrollPosition = startingScrollPosition;
    self.videosListScrollPosition = startingScrollPosition;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.usersPresenter requestedNextPage];
    [self.reelsPresenter requestedNextPage];
    [self.videosPresenter requestedNextPage];
}

- (UITableView *)tableView {
    return self.browseListTableView;
}

- (RTPagedListPresenter *)presenter {
    if (self.currentListType == BrowseUsersList) {
        return self.usersPresenter;
    }
    else if (self.currentListType == BrowseReelsList) {
        return self.reelsPresenter;
    }
    else if (self.currentListType == BrowseVideosList) {
        return self.videosPresenter;
    }
    
    DDLogError(@"Unknown presenter type: %u", self.currentListType);
    return [super presenter];
}

- (IBAction)segmentedControlChanged {
    NSInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
    
    if (selectedIndex == BrowseUsersList) {
        [self makeUsersListActive];
    }
    else if (selectedIndex == BrowseReelsList) {
        [self makeReelsListActive];
    }
    else if (selectedIndex == BrowseVideosList) {
        [self makeVideosListActive];
    }
    else {
        DDLogError(@"Received unknown segment index: %ld", (long)selectedIndex);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    if (self.currentListType == BrowseUsersList) {
        RTUserMessage *message = self.usersDataSource.items[row];
        [self.usersPresenter requestedUserDetailsForUsername:message.username];
    }
    else if (self.currentListType == BrowseReelsList) {
        RTReelMessage *message = self.reelsDataSource.items[row];
        [self.reelsPresenter requestedReelDetailsForReelId:message.reelId];
    }
    else if (self.currentListType == BrowseVideosList) {
        RTVideoMessage *message = self.videosDataSource.items[row];
        [self.videosPresenter requestedVideoDetailsForVideoId:message.videoId];
    }
    else {
        DDLogError(@"Selected row for unknown list type: %u", self.currentListType);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)makeUsersListActive {
    [self useDataSource:self.usersDataSource forType:BrowseUsersList];
    self.tableView.contentOffset = self.usersListScrollPosition;
}

- (void)makeReelsListActive {
    [self useDataSource:self.reelsDataSource forType:BrowseReelsList];
    self.tableView.contentOffset = self.reelsListScrollPosition;
}

- (void)makeVideosListActive {
    [self useDataSource:self.videosDataSource forType:BrowseVideosList];
    self.tableView.contentOffset = self.videosListScrollPosition;
}

- (void)showUserMessage:(RTUserMessage *)message {
    [self addItem:message toDataSource:self.usersDataSource forType:BrowseUsersList];
}

- (void)clearUserMessages {
    [self removeAllItemsFromDataSource:self.usersDataSource ofType:BrowseUsersList];
}

- (void)showReelMessage:(RTReelMessage *)message {
    [self addItem:message toDataSource:self.reelsDataSource forType:BrowseReelsList];
}

- (void)clearReelMessages {
    [self removeAllItemsFromDataSource:self.reelsDataSource ofType:BrowseReelsList];
}

- (void)showVideoMessage:(RTVideoMessage *)message {
    [self addItem:message toDataSource:self.videosDataSource forType:BrowseVideosList];
}

- (void)clearVideoMessages {
    [self removeAllItemsFromDataSource:self.videosDataSource ofType:BrowseVideosList];
}

- (void)useDataSource:(RTMutableArrayDataSource *)dataSource
              forType:(BrowseListType)type {
    [self rememberScrollPosition];

    self.currentListType = type;

    [self.tableView setDataSource:dataSource];
    [self.tableView reloadData];
}

- (void)rememberScrollPosition {
    CGPoint contentOffset = self.tableView.contentOffset;
    CGPoint currentScrollPosition = CGPointMake(contentOffset.x, contentOffset.y);
    
    if (self.currentListType == BrowseUsersList) {
        self.usersListScrollPosition = currentScrollPosition;
    }
    else if (self.currentListType == BrowseReelsList) {
        self.reelsListScrollPosition = currentScrollPosition;
    }
    else if (self.currentListType == BrowseVideosList) {
        self.videosListScrollPosition = currentScrollPosition;
    }
    else {
        DDLogError(@"Cannot remember scroll position for unknown type: %u", self.currentListType);
    }
}

- (void)addItem:(id)item
   toDataSource:(RTMutableArrayDataSource *)dataSource
        forType:(BrowseListType)type {
    [dataSource addItem:item];
    [self reloadTableViewIfDataSourceType:type];
}

- (void)removeAllItemsFromDataSource:(RTMutableArrayDataSource *)dataSource
                              ofType:(BrowseListType)type {
    [dataSource removeAllItems];
    [self reloadTableViewIfDataSourceType:type];
}

- (void)reloadTableViewIfDataSourceType:(BrowseListType)dataSourceType {
    if (self.currentListType == dataSourceType) {
        [self.tableView reloadData];
    }
}

@end
