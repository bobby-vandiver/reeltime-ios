#import "RTApplicationAwareWireframe.h"

@class RTChangePasswordViewController;

@interface RTChangePasswordWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTChangePasswordViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentChangePasswordInterface;

@end
