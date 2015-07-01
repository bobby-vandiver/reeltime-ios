#import "RTUserProfileWireframe.h"
#import "RTUserProfileViewController.h"

#import "RTAccountSettingsWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTUserProfileViewControllerFactory.h"

@interface RTUserProfileWireframe ()

@property id<RTUserProfileViewControllerFactory> userProfileViewControllerFactory;
@property RTAccountSettingsWireframe *accountSettingsWireframe;

@end

@implementation RTUserProfileWireframe

- (instancetype)initWithUserProfileViewControllerFactory:(id<RTUserProfileViewControllerFactory>)userProfileViewControllerFactory
                                accountSettingsWireframe:(RTAccountSettingsWireframe *)accountSettingsWireframe
                                    applicationWireframe:(RTApplicationWireframe *)applicationWireframe {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.accountSettingsWireframe = accountSettingsWireframe;
        self.userProfileViewControllerFactory = userProfileViewControllerFactory;
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

@end
