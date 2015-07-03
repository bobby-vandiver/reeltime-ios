#import <Foundation/Foundation.h>

@class RTBrowseAudienceMembersViewController;

@protocol RTBrowseAudienceMembersViewControllerFactory <NSObject>

- (RTBrowseAudienceMembersViewController *)browseAudienceMembersViewControllerForReelId:(NSNumber *)reelId;

@end
