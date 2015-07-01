#import "RTApplicationAwareWireframe.h"

#import "RTUserWireframe.h"
#import "RTReelWireframe.h"
#import "RTVideoWireframe.h"

@class RTBrowseAllViewController;
@class RTUserProfileWireframe;
@class RTApplicationWireframe;

@interface RTBrowseAllWireframe : RTApplicationAwareWireframe <RTUserWireframe, RTReelWireframe, RTVideoWireframe>

- (instancetype)initWithViewController:(RTBrowseAllViewController *)viewController
                  userProfileWireframe:(RTUserProfileWireframe *)userProfileWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

@end
