#import "RTPagedListViewScrollHandler.h"
#import "RTPagedListPresenter.h"

#import "RTArrayDataSource.h"
#import "UITableView+LastVisible.h"

@implementation RTPagedListViewScrollHandler

- (void)handleScrollForTableView:(UITableView *)tableView
                   withPresenter:(RTPagedListPresenter *)presenter {

    if (![tableView.dataSource isKindOfClass:[RTArrayDataSource class]]) {
        [NSException raise:NSInvalidArgumentException
                    format:@"Data source must be RTArrayDataSource"];
    }
    
    NSInteger lastVisibleRow = [tableView lastVisibleRowForSection:0];
    
    RTArrayDataSource *dataSource = (RTArrayDataSource *)tableView.dataSource;
    NSInteger lastItemIndex = dataSource.items.count - 1;
    
    BOOL noRowsAreVisible = (lastVisibleRow == NSNotFound);
    BOOL lastRowIsVisible = (lastVisibleRow == lastItemIndex);
    
    if (noRowsAreVisible || lastRowIsVisible) {
        [presenter requestedNextPage];
    }
}

- (void)handleScrollForCollectionView:(UICollectionView *)collectionView
                        withPresenter:(RTPagedListPresenter *)presenter {
    
}

@end
