#import "TyphoonAssembly.h"

#import "RTPlayVideoViewControllerFactory.h"

@class RTClientAssembly;
@class RTApplicationAssembly;

@class RTServiceAssembly;
@class RTCommonComponentsAssembly;

@class RTPlayVideoWireframe;
@class RTPlayerFactory;

@class RTPlayVideoIdExtractor;

@interface RTPlayVideoAssembly : TyphoonAssembly <RTPlayVideoViewControllerFactory>

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

@property (nonatomic, strong, readonly) RTServiceAssembly *serviceAssembly;
@property (nonatomic, strong, readonly) RTCommonComponentsAssembly *commonComponentsAssembly;

- (RTPlayVideoWireframe *)playVideoWireframe;

- (RTPlayerFactory *)playerFactory;

- (RTPlayVideoIdExtractor *)playVideoIdExtractor;

@end
