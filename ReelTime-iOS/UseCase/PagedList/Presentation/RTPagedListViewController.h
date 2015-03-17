#import <UIKit/UIKit.h>

@class RTPagedListPresenter;

@interface RTPagedListViewController : UIViewController <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (readonly) RTPagedListPresenter *presenter;

@end
