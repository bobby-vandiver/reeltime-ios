#import "RTApplicationAwareWireframe.h"
#import "RTUserWireframe.h"

@protocol RTBrowseAudienceMembersViewControllerFactory;
@class RTUserProfileWireframe;
@class RTApplicationWireframe;

@interface RTBrowseAudienceMembersWireframe : RTApplicationAwareWireframe <RTUserWireframe>

- (instancetype)initWithViewControllerFactory:(id<RTBrowseAudienceMembersViewControllerFactory>)viewControllerFactory
                  userProfileWireframe:(RTUserProfileWireframe *)userProfileWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentAudienceMembersForReelId:(NSNumber *)reelId;

@end
