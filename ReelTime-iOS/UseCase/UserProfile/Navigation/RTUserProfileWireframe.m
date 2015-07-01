#import "RTUserProfileWireframe.h"
#import "RTUserProfileViewController.h"

#import "RTAccountSettingsWireframe.h"
#import "RTApplicationWireframe.h"

#import "RTUserProfileViewControllerFactory.h"

@interface RTUserProfileWireframe ()

@property RTUserProfileViewController *viewController;
@property RTAccountSettingsWireframe *accountSettingsWireframe;
@property id<RTUserProfileViewControllerFactory> userProfileViewControllerFactory;

@end

@implementation RTUserProfileWireframe

- (instancetype)initWithViewController:(RTUserProfileViewController *)viewController
              accountSettingsWireframe:(RTAccountSettingsWireframe *)accountSettingsWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe
      userProfileViewControllerFactory:(id<RTUserProfileViewControllerFactory>)userProfileViewControllerFactory {

    self = [super initWithApplicationWireframe:applicationWireframe];
    if (self) {
        self.viewController = viewController;
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
