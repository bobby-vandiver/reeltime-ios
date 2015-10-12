#import "TyphoonAssembly.h"

#import "RTPlayVideoViewControllerFactory.h"
#import "RTPlayVideoConnectionFactory.h"

@class RTClientAssembly;
@class RTApplicationAssembly;

@class RTServiceAssembly;
@class RTCommonComponentsAssembly;

@class RTPlayVideoWireframe;
@class RTPlayerFactory;

@class RTPlayVideoIdExtractor;
@class RTPlayVideoURLProtocol;

@class RTPlayVideoConnectionDelegate;

@interface RTPlayVideoAssembly : TyphoonAssembly <RTPlayVideoViewControllerFactory, RTPlayVideoConnectionFactory>

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

@property (nonatomic, strong, readonly) RTServiceAssembly *serviceAssembly;
@property (nonatomic, strong, readonly) RTCommonComponentsAssembly *commonComponentsAssembly;

- (RTPlayVideoWireframe *)playVideoWireframe;

- (RTPlayerFactory *)playerFactory;

- (RTPlayVideoIdExtractor *)playVideoIdExtractor;

- (RTPlayVideoURLProtocol *)playVideoURLProtocolWithRequest:(NSURLRequest *)request
                                             cachedResponse:(NSCachedURLResponse *)cachedResponse
                                                     client:(id<NSURLProtocolClient>)client;

- (RTPlayVideoConnectionDelegate *)playVideoConnectionDelegateWithURLProtocol:(NSURLProtocol *)URLProtocol
                                                                   forVideoId:(NSNumber *)videoId;

@end
