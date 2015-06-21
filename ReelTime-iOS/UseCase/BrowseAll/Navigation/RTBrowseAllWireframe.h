#import "RTApplicationAwareWireframe.h"

#import "RTUserWireframe.h"
#import "RTReelWireframe.h"
#import "RTVideoWireframe.h"

@class RTUserProfileAssembly;
@class RTBrowseAllViewController;
@class RTApplicationWireframe;

@interface RTBrowseAllWireframe : RTApplicationAwareWireframe <RTUserWireframe, RTReelWireframe, RTVideoWireframe>

// TODO: Depend on factory protocol instead of assembly
@property RTUserProfileAssembly *userProfileAssembly;

- (instancetype)initWithViewController:(RTBrowseAllViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

@end
