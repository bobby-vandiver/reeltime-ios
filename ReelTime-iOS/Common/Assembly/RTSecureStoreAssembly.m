#import "RTSecureStoreAssembly.h"

#import "RTOAuth2TokenStore.h"
#import "RTClientCredentialsStore.h"
#import "RTCurrentUserStore.h"

@implementation RTSecureStoreAssembly

- (RTOAuth2TokenStore *)tokenStore {
    return [TyphoonDefinition withClass:[RTOAuth2TokenStore class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithKeyChainWrapper:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self.securityAssembly keyChainWrapper]];
        }];
    }];
}

- (RTClientCredentialsStore *)clientCredentialsStore {
    return [TyphoonDefinition withClass:[RTClientCredentialsStore class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithKeyChainWrapper:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self.securityAssembly keyChainWrapper]];
        }];
    }];
}

- (RTCurrentUserStore *)currentUserStore {
    return [TyphoonDefinition withClass:[RTCurrentUserStore class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithKeyChainWrapper:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self.securityAssembly keyChainWrapper]];
        }];
    }];
}

@end
