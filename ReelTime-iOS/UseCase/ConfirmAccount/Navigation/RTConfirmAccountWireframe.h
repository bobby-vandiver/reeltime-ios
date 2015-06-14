#import "RTApplicationAwareWireframe.h"

@class RTConfirmAccountViewController;

@interface RTConfirmAccountWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTConfirmAccountViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentConfirmAccountInterface;

@end
