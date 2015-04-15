#import "RTPagedListViewScrollHandler.h"
#import "RTPagedListPresenter.h"

#import "RTArrayDataSource.h"
#import "UITableView+LastVisible.h"

@implementation RTPagedListViewScrollHandler

- (void)handleScrollForTableView:(UITableView *)tableView
                   withPresenter:(RTPagedListPresenter *)presenter {
    
    NSInteger lastVisibleRow = [tableView lastVisibleRowForSection:0];
    
    // TODO: Add isKindOf check to ensure type
    RTArrayDataSource *dataSource = (RTArrayDataSource *)tableView.dataSource;
    NSInteger lastItemIndex = dataSource.items.count - 1;
    
    BOOL noRowsAreVisible = (lastVisibleRow == NSNotFound);
    BOOL lastRowIsVisible = (lastVisibleRow == lastItemIndex);
    
    if (noRowsAreVisible || lastRowIsVisible) {
        [presenter requestedNextPage];
    }
}

@end
