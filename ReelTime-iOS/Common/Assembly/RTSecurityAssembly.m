#import "RTSecurityAssembly.h"

#import "RTKeyChainWrapper.h"
#import <UICKeyChainStore/UICKeyChainStore.h>

@implementation RTSecurityAssembly

- (RTKeyChainWrapper *)keyChainWrapper {
    return [TyphoonDefinition withClass:[RTKeyChainWrapper class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithKeyChainStore:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self keyChainStore]];
        }];
    }];
}

- (UICKeyChainStore *)keyChainStore {
    return [TyphoonDefinition withClass:[UICKeyChainStore class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(keyChainStore)];
        
        NSValue *accessibility = [NSNumber numberWithInteger:UICKeyChainStoreAccessibilityWhenUnlockedThisDeviceOnly];
        [definition injectProperty:@selector(accessibility) with:accessibility];
    }];
}

@end
