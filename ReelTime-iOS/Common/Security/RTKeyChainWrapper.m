#import "RTKeyChainWrapper.h"

@interface RTKeyChainWrapper ()

@property UICKeyChainStore *keyChainStore;

@end

@implementation RTKeyChainWrapper

- (instancetype)initWithKeyChainStore:(UICKeyChainStore *)keyChainStore {
    self = [super init];
    if (self) {
        self.keyChainStore = keyChainStore;
    }
    return self;
}

- (NSData *)dataForKey:(NSString *)key
                 error:(NSError *__autoreleasing *)error{
    return [self.keyChainStore dataForKey:key];
}

- (void)setData:(NSData *)data
         forKey:(NSString *)key
          error:(NSError *__autoreleasing *)error {
    [self.keyChainStore setData:data
                         forKey:key
                          error:error];
    [self.keyChainStore synchronize];
}


@end
