#import "RTApplicationAwareWireframe.h"

@class RTLoginWireframe;

@interface RTLogoutWireframe : RTApplicationAwareWireframe

- (instancetype)initWithLoginWireframe:(RTLoginWireframe *)loginWireframe
                  applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

- (void)presentLoginInterface;

@end
