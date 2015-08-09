#import "RTApplicationAwareWireframe.h"
#import "RTVideoWireframe.h"

@protocol RTPlayVideoViewControllerFactory;
@class RTApplicationWireframe;

@interface RTPlayVideoWireframe : RTApplicationAwareWireframe <RTVideoWireframe>

- (instancetype)initWithViewControllerFactory:(id<RTPlayVideoViewControllerFactory>)viewControllerFactory
                         applicationWireframe:(RTApplicationWireframe *)applicationWireframe;

@end
