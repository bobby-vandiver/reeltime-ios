#import "RTPagedListViewController.h"
#import "RTPagedListPresenter.h"

#import "RTArrayDataSource.h"
#import "UITableView+LastVisibleRow.h"

#import "RTException.h"

@interface RTPagedListViewController ()

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
    NSInteger lastVisibleRow = [self.tableView lastVisibleRowForSection:0];
    
    RTArrayDataSource *dataSource = self.tableView.dataSource;
    NSInteger lastItemIndex = dataSource.items.count - 1;
    
    BOOL noRowsAreVisible = (lastVisibleRow == NSNotFound);
    BOOL lastRowIsVisible = (lastVisibleRow == lastItemIndex);
    
    if (noRowsAreVisible || lastRowIsVisible) {
        [self.presenter requestedNextPage];
    }
}

@end
