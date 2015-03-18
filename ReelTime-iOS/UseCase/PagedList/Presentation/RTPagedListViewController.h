#import <UIKit/UIKit.h>

@class RTPagedListPresenter;

@interface RTPagedListViewController : UIViewController <UITableViewDelegate>

@property (readonly) UITableView *tableView;

@property (readonly) UIRefreshControl *refreshControl;

@property (readonly) RTPagedListPresenter *presenter;

- (UIRefreshControl *)createRefreshControl;

@end
