#import <Typhoon/Typhoon.h>

@class RTSecureStoreAssembly;

@class RTClient;
@class RTClientDelegate;
@class RTEndpointPathFormatter;
@class RTServerErrorsConverter;
@class RTAuthenticationAwareHTTPClient;

@interface RTClientAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;

- (RTClient *)reelTimeClient;

- (RTClientDelegate *)reelTimeClientDelegate;

- (RTAuthenticationAwareHTTPClient *)authenticationAwareHTTPClient;

- (RTEndpointPathFormatter *)endpointPathFormatter;

- (RTServerErrorsConverter *)serverErrorsConverter;

@end
