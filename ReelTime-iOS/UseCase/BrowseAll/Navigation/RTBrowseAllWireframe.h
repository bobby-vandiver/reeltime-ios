#import "RTApplicationAwareWireframe.h"

#import "RTUserWireframe.h"
#import "RTReelWireframe.h"
#import "RTVideoWireframe.h"

@class RTBrowseAllViewController;
@class RTUserProfileWireframe;
@class RTPlayVideoWireframe;
@class RTApplicationWireframe;

@interface RTBrowseAllWireframe : RTApplicationAwareWireframe <RTUserWireframe, RTReelWireframe, RTVideoWireframe>

- (instancetype)initWithViewController:(RTBrowseAllViewController *)viewController
                  userProfileWireframe:(RTUserProfileWireframe *)userProfileWireframe
                    playVideoWireframe:(RTPlayVideoWireframe *)playVideoWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

@end
