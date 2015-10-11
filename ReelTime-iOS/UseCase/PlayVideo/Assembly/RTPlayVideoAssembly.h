#import "TyphoonAssembly.h"
#import "RTPlayVideoViewControllerFactory.h"

@class RTClientAssembly;
@class RTApplicationAssembly;

@class RTServiceAssembly;
@class RTCommonComponentsAssembly;

@class RTPlayVideoWireframe;
@class RTPlayerFactory;

@class RTPlayVideoConnectionFactory;
@class RTPlayVideoIdExtractor;

@class RTPlayVideoURLProtocol;

@interface RTPlayVideoAssembly : TyphoonAssembly <RTPlayVideoViewControllerFactory>

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

@property (nonatomic, strong, readonly) RTServiceAssembly *serviceAssembly;
@property (nonatomic, strong, readonly) RTCommonComponentsAssembly *commonComponentsAssembly;

- (RTPlayVideoWireframe *)playVideoWireframe;

- (RTPlayerFactory *)playerFactory;

- (RTPlayVideoConnectionFactory *)playVideoConnectionFactory;

- (RTPlayVideoIdExtractor *)playVideoIdExtractor;

- (RTPlayVideoURLProtocol *)playVideoURLProtocolWithRequest:(NSURLRequest *)request
                                             cachedResponse:(NSCachedURLResponse *)cachedResponse
                                                     client:(id<NSURLProtocolClient>)client;

@end
