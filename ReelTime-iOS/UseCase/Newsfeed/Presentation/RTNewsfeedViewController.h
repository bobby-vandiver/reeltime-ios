#import <UIKit/UIKit.h>

#import "RTNewsfeedView.h"
#import "RTStoryboardViewController.h"

@class RTNewsfeedPresenter;

@interface RTNewsfeedViewController : UIViewController <UITableViewDelegate, RTNewsfeedView, RTStoryboardViewController>

+ (RTNewsfeedViewController *)viewControllerWithPresenter:(RTNewsfeedPresenter *)presenter;

@end
