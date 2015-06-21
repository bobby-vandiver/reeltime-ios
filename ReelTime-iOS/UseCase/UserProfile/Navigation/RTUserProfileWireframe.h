#import "RTApplicationAwareWireframe.h"

@class RTUserProfileViewController;
@class RTAccountSettingsWireframe;

@interface RTUserProfileWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTUserProfileViewController *)viewController
              accountSettingsWireframe:(RTAccountSettingsWireframe *)accountSettingsWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentUserProfileInterfaceForUsername:(NSString *)username;

- (void)presentAccountSettingsInterface;

@end
