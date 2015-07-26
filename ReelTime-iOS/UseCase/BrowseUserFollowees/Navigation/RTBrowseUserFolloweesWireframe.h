#import "RTApplicationAwareWireframe.h"
#import "RTUserWireframe.h"

@protocol RTBrowseUserFolloweesViewControllerFactory;
@class RTUserProfileWireframe;
@class RTApplicationWireframe;

@interface RTBrowseUserFolloweesWireframe : RTApplicationAwareWireframe <RTUserWireframe>

- (instancetype)initWithViewControllerFactory:(id<RTBrowseUserFolloweesViewControllerFactory>)viewControllerFactory
                         userProfileWireframe:(RTUserProfileWireframe *)userProfileWireframe
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentFolloweesForUsername:(NSString *)username;

@end
