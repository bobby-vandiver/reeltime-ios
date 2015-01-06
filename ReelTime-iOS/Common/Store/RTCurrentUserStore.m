#import "RTCurrentUserStore.h"

static NSString *const KEY = @"current-username";

@interface RTCurrentUserStore ()

@property RTKeyChainWrapper *keyChainWrapper;

@end

@implementation RTCurrentUserStore

- (instancetype)initWithKeyChainWrapper:(RTKeyChainWrapper *)keyChainWrapper {
    self = [super init];
    if (self) {
        self.keyChainWrapper = keyChainWrapper;
    }
    return self;
}

- (NSString *)loadCurrentUsernameWithError:(NSError *__autoreleasing *)error {
    return (NSString *)[self.keyChainWrapper objectForKey:KEY error:error];
}

- (BOOL)storeCurrentUsername:(NSString *)username
                       error:(NSError *__autoreleasing *)error {
    return [self.keyChainWrapper setObject:username
                                    forKey:KEY
                                     error:error];
}

@end
