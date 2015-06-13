#import "RTApplicationAwareWireframe.h"

@class RTChangeDisplayNameViewController;

@interface RTChangeDisplayNameWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTChangeDisplayNameViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentChangeDisplayNameInterface;

@end
