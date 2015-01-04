#import "RTClientCredentialsStore.h"

@interface RTClientCredentialsStore ()

@property RTKeyChainWrapper *keyChainWrapper;

@end

@implementation RTClientCredentialsStore

- (instancetype)initWithKeyChainWrapper:(RTKeyChainWrapper *)keyChainWrapper {
    self = [super init];
    if (self) {
        self.keyChainWrapper = keyChainWrapper;
    }
    return self;
}

- (RTClientCredentials *)loadClientCredentialsForUsername:(NSString *)username {
    return (RTClientCredentials *)[self.keyChainWrapper objectForKey:[self generateKeyForUsername:username]
                                                               error:nil];
}

- (BOOL)storeClientCredentials:(RTClientCredentials *)credentials
                   forUsername:(NSString *)username
                         error:(RTError *__autoreleasing *)error {
    return [self.keyChainWrapper setObject:credentials
                                    forKey:[self generateKeyForUsername:username]
                                     error:error];
}

- (NSString *)generateKeyForUsername:(NSString *)username {
    return [NSString stringWithFormat:@"%@-client", username];
}

@end
