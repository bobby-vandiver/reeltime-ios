#import "RTUserProfileWireframe.h"
#import "RTUserProfileViewController.h"

#import "RTAccountSettingsWireframe.h"
#import "RTBrowseAudienceMembersWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTUserProfileViewControllerFactory.h"

@interface RTUserProfileWireframe ()

@property id<RTUserProfileViewControllerFactory> userProfileViewControllerFactory;

@property RTAccountSettingsWireframe *accountSettingsWireframe;
@property RTBrowseAudienceMembersWireframe *browseAudienceMembersWireframe;

@end

@implementation RTUserProfileWireframe

- (instancetype)initWithUserProfileViewControllerFactory:(id<RTUserProfileViewControllerFactory>)userProfileViewControllerFactory
                                accountSettingsWireframe:(RTAccountSettingsWireframe *)accountSettingsWireframe
                          browseAudienceMembersWireframe:(RTBrowseAudienceMembersWireframe *)browseAudienceMembersWireframe
                                    applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.userProfileViewControllerFactory = userProfileViewControllerFactory;
        self.accountSettingsWireframe = accountSettingsWireframe;
        self.browseAudienceMembersWireframe = browseAudienceMembersWireframe;
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

@end
