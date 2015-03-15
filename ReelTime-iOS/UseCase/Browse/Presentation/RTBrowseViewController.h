#import <UIKit/UIKit.h>

#import "RTBrowseUsersView.h"
#import "RTBrowseReelsView.h"
#import "RTBrowseVideosView.h"
#import "RTStoryboardViewController.h"

@class RTBrowseUsersPresenter;
@class RTBrowseReelsPresenter;
@class RTBrowseVideosPresenter;
@class RTArrayDataSource;

@interface RTBrowseViewController : UIViewController <RTBrowseUsersView, RTBrowseReelsView, RTBrowseVideosView, RTStoryboardViewController>

@property (readonly) RTArrayDataSource *tableViewDataSource;

+ (RTBrowseViewController *)viewControllerWithUsersPresenter:(RTBrowseUsersPresenter *)usersPresenter
                                              reelsPresenter:(RTBrowseReelsPresenter *)reelsPresenter
                                             videosPresenter:(RTBrowseVideosPresenter *)videosPresenter;

@end
