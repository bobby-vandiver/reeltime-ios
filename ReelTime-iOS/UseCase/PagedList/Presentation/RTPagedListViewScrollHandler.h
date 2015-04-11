#import <Foundation/Foundation.h>

@class UITableView;
@class RTPagedListPresenter;

@interface RTPagedListViewScrollHandler : NSObject

- (void)handleScrollForTableView:(UITableView *)tableView
                   withPresenter:(RTPagedListPresenter *)presenter;

@end
