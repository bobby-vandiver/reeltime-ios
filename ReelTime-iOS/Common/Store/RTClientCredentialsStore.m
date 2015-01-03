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
    NSData *encodedCredentials = [self.keyChainWrapper dataForKey:[self generateKeyForUsername:username]
                                                            error:nil];
    if (encodedCredentials) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedCredentials];
    }
    return nil;
}

- (BOOL)storeClientCredentials:(RTClientCredentials *)credentials
                   forUsername:(NSString *)username
                         error:(NSError *__autoreleasing *)error {
    NSError *keyChainStoreError;
    [self.keyChainWrapper setData:[NSKeyedArchiver archivedDataWithRootObject:credentials]
                           forKey:[self generateKeyForUsername:username]
                            error:&keyChainStoreError];
    
    if (keyChainStoreError) {
    }
    
    return YES;
}

- (NSString *)generateKeyForUsername:(NSString *)username {
    return [NSString stringWithFormat:@"%@-client", username];
}

@end
