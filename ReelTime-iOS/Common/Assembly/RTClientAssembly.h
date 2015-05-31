#import <Typhoon/Typhoon.h>

@class RTSecureStoreAssembly;

@class RTAPIClient;
@class RTAuthenticationAwareHTTPClient;
@class RTAuthenticationAwareHTTPClientDelegate;
@class RKObjectManager;
@class RTEndpointPathFormatter;

@interface RTClientAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;

- (RTAPIClient *)reelTimeClient;

- (RTAuthenticationAwareHTTPClient *)authenticationAwareHTTPClient;

- (RTAuthenticationAwareHTTPClientDelegate *)authenticationAwareHTTPClientDelegate;

- (RKObjectManager *)restKitObjectManager;

- (RTEndpointPathFormatter *)endpointPathFormatter;

@end
