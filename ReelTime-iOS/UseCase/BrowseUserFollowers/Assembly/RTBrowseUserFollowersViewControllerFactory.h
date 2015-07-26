#import <Foundation/Foundation.h>

@class RTBrowseUserFollowersViewController;

@protocol RTBrowseUserFollowersViewControllerFactory <NSObject>

- (RTBrowseUserFollowersViewController *)browseUserFollowersViewControllerForUsername:(NSString *)username;

@end
