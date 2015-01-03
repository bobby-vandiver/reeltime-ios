#import "RTClientCredentialsStore.h"

@interface RTClientCredentialsStore ()

@property UICKeyChainStore *keyChainStore;

@end

@implementation RTClientCredentialsStore

- (instancetype)initWithKeyChainStore:(UICKeyChainStore *)keyChainStore {
    self = [super init];
    if (self) {
        self.keyChainStore = keyChainStore;
    }
    return self;
}

- (RTClientCredentials *)loadClientCredentialsForUsername:(NSString *)username {
    NSData *encodedCredentials = [self.keyChainStore dataForKey:[self generateKeyForUsername:username]];
    if (encodedCredentials) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedCredentials];
    }
    return nil;
}

- (BOOL)storeClientCredentials:(RTClientCredentials *)credentials
                   forUsername:(NSString *)username
                         error:(NSError *__autoreleasing *)error {
    NSError *keyChainStoreError;
    [self.keyChainStore setData:[NSKeyedArchiver archivedDataWithRootObject:credentials]
                         forKey:[self generateKeyForUsername:username]
                          error:&keyChainStoreError];
    [self.keyChainStore synchronize];
    
    if (keyChainStoreError) {
    }
    
    return YES;
}

- (NSString *)generateKeyForUsername:(NSString *)username {
    return [NSString stringWithFormat:@"%@-client", username];
}

@end
