#import <UIKit/UIKit.h>

#import "RTNewsfeedView.h"
#import "RTStoryboardViewController.h"

@class RTNewsfeedPresenter;
@class RTArrayDataSource;

@interface RTNewsfeedViewController : UIViewController <UITableViewDelegate, RTNewsfeedView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (readonly) RTArrayDataSource *dataSource;

+ (RTNewsfeedViewController *)viewControllerWithPresenter:(RTNewsfeedPresenter *)presenter;

@end
