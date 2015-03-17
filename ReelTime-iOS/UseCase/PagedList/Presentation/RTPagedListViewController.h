#import <UIKit/UIKit.h>

@class RTPagedListPresenter;

@interface RTPagedListViewController : UIViewController <UITableViewDelegate>

@property (readonly) UITableView *tableView;

@property (readonly) RTPagedListPresenter *presenter;

@end
