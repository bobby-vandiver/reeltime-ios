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

- (id<NSSecureCoding>)objectForKey:(NSString *)key
                             error:(NSError *__autoreleasing *)error {
    NSData *encodedData = [self.keyChainStore dataForKey:key error:error];
    if (encodedData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
    }
    return nil;
}

- (BOOL)setObject:(id<NSSecureCoding>)object
           forKey:(NSString *)key
            error:(NSError *__autoreleasing *)error {
    [self.keyChainStore setData:[NSKeyedArchiver archivedDataWithRootObject:object]
                         forKey:key];
    [self.keyChainStore synchronizeWithError:error];
    return error == nil;
}

@end
