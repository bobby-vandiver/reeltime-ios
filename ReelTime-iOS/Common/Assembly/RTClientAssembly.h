#import <Typhoon/Typhoon.h>

@class RTSecureStoreAssembly;

@class RTClient;
@class RTClientDelegate;
@class RTServerErrorsConverter;

@interface RTClientAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;

- (RTClient *)reelTimeClient;

- (RTClientDelegate *)reelTimeClientDelegate;

- (RTServerErrorsConverter *)serverErrorsConverter;

@end
