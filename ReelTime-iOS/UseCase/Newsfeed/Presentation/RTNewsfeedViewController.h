#import "RTPagedListViewController.h"

#import "RTNewsfeedView.h"
#import "RTStoryboardViewController.h"

@class RTNewsfeedPresenter;
@class RTArrayDataSource;

@interface RTNewsfeedViewController : RTPagedListViewController <RTNewsfeedView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITableView *activitiesTableView;

+ (instancetype)viewControllerWithPresenter:(RTNewsfeedPresenter *)presenter;

@end
