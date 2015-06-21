#import "RTApplicationAwareWireframe.h"

#import "RTUserWireframe.h"
#import "RTReelWireframe.h"
#import "RTVideoWireframe.h"

@class RTBrowseAllViewController;
@class RTApplicationWireframe;
@protocol RTUserProfileViewControllerFactory;

@interface RTBrowseAllWireframe : RTApplicationAwareWireframe <RTUserWireframe, RTReelWireframe, RTVideoWireframe>

- (instancetype)initWithViewController:(RTBrowseAllViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe
      userProfileViewControllerFactory:(id<RTUserProfileViewControllerFactory>)userProfileViewControllerFactory;

@end
