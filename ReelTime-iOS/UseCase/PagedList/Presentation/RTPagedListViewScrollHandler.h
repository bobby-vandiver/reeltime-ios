#import <Foundation/Foundation.h>

@class RTPagedListPresenter;

@class UITableView;
@class UICollectionView;

@interface RTPagedListViewScrollHandler : NSObject

- (void)handleScrollForTableView:(UITableView *)tableView
                   withPresenter:(RTPagedListPresenter *)presenter;

- (void)handleScrollForCollectionView:(UICollectionView *)collectionView
                        withPresenter:(RTPagedListPresenter *)presenter;

@end
