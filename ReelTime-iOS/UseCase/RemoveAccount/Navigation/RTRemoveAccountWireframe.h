#import "RTApplicationAwareWireframe.h"

@class RTRemoveAccountViewController;

@interface RTRemoveAccountWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTRemoveAccountViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentRemoveAccountInterface;

- (void)presentPostRemoveAccountInterface;

@end
