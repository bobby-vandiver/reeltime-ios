#import <Foundation/Foundation.h>

@class RTUserProfileViewController;

@protocol RTUserProfileViewControllerFactory <NSObject>

- (RTUserProfileViewController *)userProfileViewControllerForUsername:(NSString *)username;

@end
