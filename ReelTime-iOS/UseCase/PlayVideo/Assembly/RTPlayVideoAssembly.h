#import "TyphoonAssembly.h"
#import "RTPlayVideoViewControllerFactory.h"

@class RTClientAssembly;
@class RTApplicationAssembly;

@class RTCommonComponentsAssembly;

@class RTPlayVideoWireframe;
@class RTPlayerFactory;

@interface RTPlayVideoAssembly : TyphoonAssembly <RTPlayVideoViewControllerFactory>

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;
@property (nonatomic, strong, readonly) RTCommonComponentsAssembly *commonComponentsAssembly;

- (RTPlayVideoWireframe *)playVideoWireframe;

- (RTPlayerFactory *)playerFactory;

@end
