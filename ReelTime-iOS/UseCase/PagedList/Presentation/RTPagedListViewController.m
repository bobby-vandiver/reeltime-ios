#import "RTPagedListViewController.h"
#import "RTPagedListPresenter.h"

#import "RTPagedListViewScrollHandler.h"
#import "RTException.h"

@interface RTPagedListViewController ()

@property (readwrite) RTPagedListViewScrollHandler *scrollHandler;
@property (readwrite) UIRefreshControl *refreshControl;

@end

@implementation RTPagedListViewController

- (UITableView *)tableView {
    [NSException raise:RTAbstractMethodException
                format:@"Table view must be provided by subclass"];
    return nil;
}

- (RTPagedListPresenter *)presenter {
    [NSException raise:RTAbstractMethodException
                format:@"Presenter must be provided by subclass"];
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerScrollHandler];
    [self registerRefreshControl];
}

- (void)registerScrollHandler {
    self.scrollHandler = [[RTPagedListViewScrollHandler alloc] init];
}

- (void)registerRefreshControl {
    UIRefreshControl *refreshControl = [self createRefreshControl];
    
    if (refreshControl) {
        [refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
        
        self.refreshControl = refreshControl;
        [self.tableView addSubview:refreshControl];
    }
}

- (UIRefreshControl *)createRefreshControl {
    return nil;
}

- (void)handleRefresh {
    [self.presenter requestedRefreshWithCallback:^{
        [self.refreshControl endRefreshing];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.scrollHandler handleScrollForTableView:self.tableView withPresenter:self.presenter];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

@end
