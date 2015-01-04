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

- (RTOAuth2Token *)loadTokenForUsername:(NSString *)username
                                  error:(NSError *__autoreleasing *)outError {
    return (RTOAuth2Token *)[self.keyChainWrapper objectForKey:[self generateKeyForUsername:username]
                                                         error:outError];
}

- (BOOL)storeToken:(RTOAuth2Token *)token
       forUsername:(NSString *)username
             error:(NSError *__autoreleasing *)outError {
    return [self.keyChainWrapper setObject:token
                                    forKey:[self generateKeyForUsername:username]
                                     error:outError];
}

- (NSString *)generateKeyForUsername:(NSString *)username {
    return [NSString stringWithFormat:@"%@-token", username];
}

@end
