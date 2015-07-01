#import "RTApplicationAwareWireframe.h"
#import "RTUserWireframe.h"

@class RTUserProfileViewController;
@class RTAccountSettingsWireframe;
@protocol RTUserProfileViewControllerFactory;

@interface RTUserProfileWireframe : RTApplicationAwareWireframe <RTUserWireframe>

- (instancetype)initWithViewController:(RTUserProfileViewController *)viewController
              accountSettingsWireframe:(RTAccountSettingsWireframe *)accountSettingsWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe
      userProfileViewControllerFactory:(id<RTUserProfileViewControllerFactory>)userProfileViewControllerFactory;

- (void)presentAccountSettingsInterface;

@end
