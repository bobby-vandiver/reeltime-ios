#import <Typhoon/Typhoon.h>

@class RTSecureStoreAssembly;

@class RTCurrentUserService;
@class RTClientCredentialsService;

@interface RTServiceAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTSecureStoreAssembly *secureStoreAssembly;

- (RTCurrentUserService *)currentUserService;

- (RTClientCredentialsService *)clientCredentialsService;

@end
