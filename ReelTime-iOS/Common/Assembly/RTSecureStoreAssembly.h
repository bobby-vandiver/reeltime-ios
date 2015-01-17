#import <Typhoon/Typhoon.h>
#import "RTSecurityAssembly.h"

@class RTOAuth2TokenStore;
@class RTClientCredentialsStore;
@class RTCurrentUserStore;

@interface RTSecureStoreAssembly : TyphoonAssembly

@property(nonatomic, strong, readonly) RTSecurityAssembly *securityAssembly;

- (RTOAuth2TokenStore *)tokenStore;

- (RTClientCredentialsStore *)clientCredentialsStore;

- (RTCurrentUserStore *)currentUserStore;

@end
