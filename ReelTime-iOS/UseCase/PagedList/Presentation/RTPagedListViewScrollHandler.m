#import "RTPagedListViewScrollHandler.h"
#import "RTPagedListPresenter.h"

#import "RTArrayDataSource.h"

#import "UITableView+LastVisible.h"
#import "UICollectionView+LastVisible.h"

#import "RTLogging.h"

@implementation RTPagedListViewScrollHandler

- (void)handleScrollForTableView:(UITableView *)tableView
                   withPresenter:(RTPagedListPresenter *)presenter {

    if (![tableView.dataSource isKindOfClass:[RTArrayDataSource class]]) {
        [NSException raise:NSInvalidArgumentException
                    format:@"Table view data source must be RTArrayDataSource"];
    }
    
    NSInteger lastVisibleSection = [tableView lastVisibleSection];
    NSInteger lastVisibleRow = [tableView lastVisibleRowForSection:lastVisibleSection];
    
    RTArrayDataSource *dataSource = (RTArrayDataSource *)tableView.dataSource;
    [self handleScrollForDataSource:dataSource lastVisibleRow:lastVisibleRow withPresenter:presenter];
}

- (void)handleScrollForCollectionView:(UICollectionView *)collectionView
                        withPresenter:(RTPagedListPresenter *)presenter {

    if (![collectionView.dataSource isKindOfClass:[RTArrayDataSource class]]) {
        [NSException raise:NSInvalidArgumentException
                    format:@"Collection view data source must be RTArrayDataSource"];
    }
    
    NSInteger lastVisibleSection = [collectionView lastVisibleSection];
    NSInteger lastVisibleRow = [collectionView lastVisibleRowForSection:lastVisibleSection];
    
    RTArrayDataSource *dataSource = (RTArrayDataSource *)collectionView.dataSource;
    [self handleScrollForDataSource:dataSource lastVisibleRow:lastVisibleRow withPresenter:presenter];
}

- (void)handleScrollForDataSource:(RTArrayDataSource *)dataSource
                   lastVisibleRow:(NSInteger)lastVisibleRow
                    withPresenter:(RTPagedListPresenter *)presenter {
    
    NSInteger lastItemIndex = dataSource.items.count - 1;

    BOOL noRowsAreVisible = (lastVisibleRow == NSNotFound);
    BOOL lastRowIsVisible = (lastVisibleRow == lastItemIndex);
    
    if (noRowsAreVisible || lastRowIsVisible) {
        [presenter requestedNextPage];
    }
}

@end
