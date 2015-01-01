#import "RTOAuth2TokenStore.h"

@interface RTOAuth2TokenStore ()

@property UICKeyChainStore *keyChainStore;

@end

@implementation RTOAuth2TokenStore

- (instancetype)initWithKeyChainStore:(UICKeyChainStore *)keyChainStore {
    self = [super init];
    if (self) {
        self.keyChainStore = keyChainStore;
    }
    return self;
}

- (BOOL)storeToken:(RTOAuth2Token *)token
             error:(NSError *__autoreleasing *)outError {
    return NO;
}

@end
