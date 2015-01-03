#import "RTOAuth2TokenStore.h"

@interface RTOAuth2TokenStore ()

@property RTKeyChainWrapper *keyChainWrapper;

@end

@implementation RTOAuth2TokenStore

- (instancetype)initWithKeyChainWrapper:(RTKeyChainWrapper *)keyChainWrapper {
    self = [super init];
    if (self) {
        self.keyChainWrapper = keyChainWrapper;
    }
    return self;
}

- (BOOL)storeToken:(RTOAuth2Token *)token
       forUsername:(NSString *)username
             error:(NSError *__autoreleasing *)outError {
    return NO;
}

@end
