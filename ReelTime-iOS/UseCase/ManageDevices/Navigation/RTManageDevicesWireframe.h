#import "RTApplicationAwareWireframe.h"

@class RTManageDevicesViewController;
@class RTApplicationWireframe;
@class RTLoginWireframe;

@interface RTManageDevicesWireframe : RTApplicationAwareWireframe

- (instancetype)initWithViewController:(RTManageDevicesViewController *)viewController
                        loginWireframe:(RTLoginWireframe *)loginWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentManageDevicesInterface;

- (void)presentLoginInterface;

@end
