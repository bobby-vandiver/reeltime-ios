#import "RTApplicationAwareWireframe.h"
#import "RTUserWireframe.h"

@protocol RTUserProfileViewControllerFactory;
@class RTAccountSettingsWireframe;
@class RTBrowseAudienceMembersWireframe;

@interface RTUserProfileWireframe : RTApplicationAwareWireframe <RTUserWireframe>

- (instancetype)initWithUserProfileViewControllerFactory:(id<RTUserProfileViewControllerFactory>)userProfileViewControllerFactory
                                accountSettingsWireframe:(RTAccountSettingsWireframe *)accountSettingsWireframe
                          browseAudienceMembersWireframe:(RTBrowseAudienceMembersWireframe *)browseAudienceMembersWireframe
                                    applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentAccountSettingsInterface;

- (void)presentAudienceMembersForReelId:(NSNumber *)reelId;

@end
