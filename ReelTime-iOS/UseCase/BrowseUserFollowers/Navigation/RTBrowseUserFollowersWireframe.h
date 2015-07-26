#import "RTApplicationAwareWireframe.h"
#import "RTUserWireframe.h"

@protocol RTBrowseUserFollowersViewControllerFactory;
@class RTUserProfileWireframe;
@class RTApplicationWireframe;

@interface RTBrowseUserFollowersWireframe : RTApplicationAwareWireframe <RTUserWireframe>

- (instancetype)initWithViewControllerFactory:(id<RTBrowseUserFollowersViewControllerFactory>)viewControllerFactory
                         userProfileWireframe:(RTUserProfileWireframe *)userProfileWireframe
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentFollowersForUsername:(NSString *)username;

@end
