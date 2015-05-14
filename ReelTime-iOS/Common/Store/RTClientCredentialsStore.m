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
    return [self loadClientCredentialsForUsername:username error:nil];
}

- (RTClientCredentials *)loadClientCredentialsForUsername:(NSString *)username
                                                    error:(NSError *__autoreleasing *)error {
    return (RTClientCredentials *)[self.keyChainWrapper objectForKey:[self generateKeyForUsername:username]
                                                               error:error];
}

- (BOOL)storeClientCredentials:(RTClientCredentials *)credentials
                   forUsername:(NSString *)username
                         error:(NSError *__autoreleasing *)error {
    return [self.keyChainWrapper setObject:credentials
                                    forKey:[self generateKeyForUsername:username]
                                     error:error];
}

- (NSString *)generateKeyForUsername:(NSString *)username {
    return [NSString stringWithFormat:@"%@-client", username];
}

@end
