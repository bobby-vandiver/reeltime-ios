#import <Typhoon/Typhoon.h>

@class RTSecureStoreAssembly;

@class RTClient;
@class RTAuthenticationAwareHTTPClient;
@class RTAuthenticationAwareHTTPClientDelegate;
@class RTEndpointPathFormatter;
@class RTServerErrorsConverter;

@interface RTClientAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;

- (RTClient *)reelTimeClient;

- (RTAuthenticationAwareHTTPClient *)authenticationAwareHTTPClient;

- (RTAuthenticationAwareHTTPClientDelegate *)authenticationAwareHTTPClientDelegate;

- (RTEndpointPathFormatter *)endpointPathFormatter;

- (RTServerErrorsConverter *)serverErrorsConverter;

@end
