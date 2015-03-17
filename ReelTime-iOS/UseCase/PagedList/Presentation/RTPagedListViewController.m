#import "RTPagedListViewController.h"
#import "RTPagedListPresenter.h"

#import "RTArrayDataSource.h"
#import "UITableView+LastVisibleRow.h"

#import "RTException.h"

@implementation RTPagedListViewController

- (RTPagedListPresenter *)presenter {
    [NSException raise:RTAbstractMethodException
                format:@"Presenter must be provided by subclass"];
    return nil;
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
