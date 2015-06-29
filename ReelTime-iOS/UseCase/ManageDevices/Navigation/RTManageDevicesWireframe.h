#import "RTApplicationAwareWireframe.h"

@class RTManageDevicesViewController;
@class RTApplicationWireframe;

@interface RTManageDevicesWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTManageDevicesViewController *)viewController
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentManageDevicesInterface;

- (void)presentLoginInterface;

@end
