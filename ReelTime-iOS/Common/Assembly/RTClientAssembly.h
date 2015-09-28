#import <Typhoon/Typhoon.h>

@class RTSecureStoreAssembly;
@class RTServiceAssembly;

@class RTAPIClient;
@class RTAuthenticationAwareHTTPClient;
@class RTAuthenticationAwareHTTPClientDelegate;
@class RKObjectManager;
@class RTEndpointPathFormatter;

@interface RTClientAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;
@property (nonatomic, strong, readonly) RTServiceAssembly *serviceAssembly;

- (RTAPIClient *)reelTimeClient;

- (RTAuthenticationAwareHTTPClient *)authenticationAwareHTTPClient;

- (RTAuthenticationAwareHTTPClientDelegate *)authenticationAwareHTTPClientDelegate;

- (RKObjectManager *)restKitObjectManager;

- (RTEndpointPathFormatter *)endpointPathFormatter;

- (NSURL *)baseUrl;

@end
