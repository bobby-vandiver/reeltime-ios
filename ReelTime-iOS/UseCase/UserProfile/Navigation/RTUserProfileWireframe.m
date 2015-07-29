#import "RTUserProfileWireframe.h"
#import "RTUserProfileViewController.h"

#import "RTAccountSettingsWireframe.h"
#import "RTBrowseAudienceMembersWireframe.h"

#import "RTBrowseUserFollowersWireframe.h"
#import "RTBrowseUserFolloweesWireframe.h"

#import "RTApplicationWireframe.h"

#import "RTUserProfileViewControllerFactory.h"

@interface RTUserProfileWireframe ()

@property id<RTUserProfileViewControllerFactory> userProfileViewControllerFactory;

@property RTAccountSettingsWireframe *accountSettingsWireframe;
@property RTBrowseAudienceMembersWireframe *browseAudienceMembersWireframe;

@property RTBrowseUserFollowersWireframe *browseUserFollowersWireframe;
@property RTBrowseUserFolloweesWireframe *browseUserFolloweesWireframe;

@end

@implementation RTUserProfileWireframe

- (instancetype)initWithUserProfileViewControllerFactory:(id<RTUserProfileViewControllerFactory>)userProfileViewControllerFactory
                                accountSettingsWireframe:(RTAccountSettingsWireframe *)accountSettingsWireframe
                          browseAudienceMembersWireframe:(RTBrowseAudienceMembersWireframe *)browseAudienceMembersWireframe
                            browseUserFollowersWireframe:(RTBrowseUserFollowersWireframe *)browseUserFollowersWireframe
                            browseUserFolloweesWireframe:(RTBrowseUserFolloweesWireframe *)browseUserFolloweesWireframe
                                    applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.userProfileViewControllerFactory = userProfileViewControllerFactory;
        self.accountSettingsWireframe = accountSettingsWireframe;
        self.browseAudienceMembersWireframe = browseAudienceMembersWireframe;
        self.browseUserFollowersWireframe = browseUserFollowersWireframe;
        self.browseUserFolloweesWireframe = browseUserFolloweesWireframe;
    }
    return self;
}

- (void)presentAccountSettingsInterface {
    [self.accountSettingsWireframe presentAccountSettingsInterface];
}

- (void)presentUserForUsername:(NSString *)username {
    RTUserProfileViewController *userProfileViewController = [self.userProfileViewControllerFactory userProfileViewControllerForUsername:username];
    [self.applicationWireframe navigateToViewController:userProfileViewController];
}

- (void)presentAudienceMembersForReelId:(NSNumber *)reelId {
    [self.browseAudienceMembersWireframe presentAudienceMembersForReelId:reelId];
}

- (void)presentFollowersForUsername:(NSString *)username {
    [self.browseUserFollowersWireframe presentFollowersForUsername:username];
}

- (void)presentFolloweesForUsername:(NSString *)username {
    [self.browseUserFolloweesWireframe presentFolloweesForUsername:username];
}

@end
