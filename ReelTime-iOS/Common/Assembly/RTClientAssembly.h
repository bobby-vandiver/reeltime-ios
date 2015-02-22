#import <Typhoon/Typhoon.h>

@class RTSecureStoreAssembly;

@class RTClient;
@class RTClientDelegate;
@class RTEndpointPathFormatter;
@class RTServerErrorsConverter;

@interface RTClientAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;

- (RTClient *)reelTimeClient;

- (RTClientDelegate *)reelTimeClientDelegate;

- (RTEndpointPathFormatter *)endpointPathFormatter;

- (RTServerErrorsConverter *)serverErrorsConverter;

@end
