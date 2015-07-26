#import <Foundation/Foundation.h>

@class RTBrowseUserFolloweesViewController;

@protocol RTBrowseUserFolloweesViewControllerFactory <NSObject>

- (RTBrowseUserFolloweesViewController *)browseUserFolloweesViewControllerForUsername:(NSString *)username;

@end
