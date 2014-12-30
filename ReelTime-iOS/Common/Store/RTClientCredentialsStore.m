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

- (RTClientCredentials *)loadClientCredentials {
    return nil;
}

@end
