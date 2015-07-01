#import "RTApplicationAwareWireframe.h"
#import "RTUserWireframe.h"

@protocol RTUserProfileViewControllerFactory;
@class RTAccountSettingsWireframe;

@interface RTUserProfileWireframe : RTApplicationAwareWireframe <RTUserWireframe>

- (instancetype)initWithUserProfileViewControllerFactory:(id<RTUserProfileViewControllerFactory>)userProfileViewControllerFactory
                                accountSettingsWireframe:(RTAccountSettingsWireframe *)accountSettingsWireframe
                                    applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentAccountSettingsInterface;

@end
