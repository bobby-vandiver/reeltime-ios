#import "RTApplicationAwareWireframe.h"
#import "RTUserWireframe.h"

@protocol RTUserProfileViewControllerFactory;

@class RTAccountSettingsWireframe;
@class RTBrowseAudienceMembersWireframe;

@class RTBrowseUserFollowersWireframe;
@class RTBrowseUserFolloweesWireframe;

@interface RTUserProfileWireframe : RTApplicationAwareWireframe <RTUserWireframe>

- (instancetype)initWithUserProfileViewControllerFactory:(id<RTUserProfileViewControllerFactory>)userProfileViewControllerFactory
                                accountSettingsWireframe:(RTAccountSettingsWireframe *)accountSettingsWireframe
                          browseAudienceMembersWireframe:(RTBrowseAudienceMembersWireframe *)browseAudienceMembersWireframe
                            browseUserFollowersWireframe:(RTBrowseUserFollowersWireframe *)browseUserFollowersWireframe
                            browseUserFolloweesWireframe:(RTBrowseUserFolloweesWireframe *)browseUserFolloweesWireframe
                                    applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentAccountSettingsInterface;

- (void)presentAudienceMembersForReelId:(NSNumber *)reelId;

- (void)presentFollowersForUsername:(NSString *)username;

- (void)presentFolloweesForUsername:(NSString *)username;

@end
