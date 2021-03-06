#import "RTServiceAssembly.h"
#import "RTSecureStoreAssembly.h"

#import "RTCurrentUserService.h"
#import "RTClientCredentialsService.h"

@implementation RTServiceAssembly

- (RTCurrentUserService *)currentUserService {
    return [TyphoonDefinition withClass:[RTCurrentUserService class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithCurrentUserStore:clientCredentialsStore:tokenStore:)
                      parameters:^(TyphoonMethod *method) {
                          [method injectParameterWith:[self.secureStoreAssembly currentUserStore]];
                          [method injectParameterWith:[self.secureStoreAssembly clientCredentialsStore]];
                          [method injectParameterWith:[self.secureStoreAssembly tokenStore]];
        }];
    }];
}

- (RTClientCredentialsService *)clientCredentialsService {
    return [TyphoonDefinition withClass:[RTClientCredentialsService class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(initWithClientCredentialsStore:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self.secureStoreAssembly clientCredentialsStore]];
        }];
    }];
}

@end
