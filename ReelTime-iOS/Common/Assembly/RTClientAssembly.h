#import <Typhoon/Typhoon.h>

@class RTSecureStoreAssembly;
@class RTServiceAssembly;
@class RTLoginAssembly;

@class RTAPIClient;
@class RTAuthenticationAwareHTTPClient;
@class RTAuthenticationAwareHTTPClientDelegate;
@class RKObjectManager;
@class RTEndpointPathFormatter;

@interface RTClientAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;
@property (nonatomic, strong, readonly) RTServiceAssembly *serviceAssembly;
@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;

- (RTAPIClient *)reelTimeClient;

- (RTAuthenticationAwareHTTPClient *)authenticationAwareHTTPClient;

- (RTAuthenticationAwareHTTPClientDelegate *)authenticationAwareHTTPClientDelegate;

- (RKObjectManager *)restKitObjectManager;

- (RTEndpointPathFormatter *)endpointPathFormatter;

- (NSURL *)baseUrl;

@end
