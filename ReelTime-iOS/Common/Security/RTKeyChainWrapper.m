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

- (id<NSCoding>)objectForKey:(NSString *)key
                       error:(NSError *__autoreleasing *)error {
    NSData *encodedData = [self.keyChainStore dataForKey:key];
    if (encodedData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
    }
    return nil;
}

- (void)setObject:(id<NSCoding>)object
           forKey:(NSString *)key
            error:(NSError *__autoreleasing *)error {
    [self.keyChainStore setData:[NSKeyedArchiver archivedDataWithRootObject:object]
                         forKey:key];
    [self.keyChainStore synchronizeWithError:error];
}

@end
