#import "TyphoonAssembly.h"
#import "RTPlayVideoViewControllerFactory.h"

@class RTApplicationAssembly;
@class RTPlayVideoWireframe;

@interface RTPlayVideoAssembly : TyphoonAssembly <RTPlayVideoViewControllerFactory>

@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTPlayVideoWireframe *)playVideoWireframe;

@end
