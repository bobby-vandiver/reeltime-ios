#import "RTKeyChainWrapper.h"
#import "RTErrorFactory.h"

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
    NSError *keyChainStoreError;
    NSData *encodedData = [self.keyChainStore dataForKey:key error:&keyChainStoreError];
    if (encodedData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
    }
    if (error) {
        *error = [self mapKeyChainStoreError:keyChainStoreError];
    }
    return nil;
}

- (BOOL)setObject:(id<NSSecureCoding>)object
           forKey:(NSString *)key
            error:(NSError *__autoreleasing *)error {
    [self.keyChainStore setData:[NSKeyedArchiver archivedDataWithRootObject:object]
                         forKey:key];
    
    NSError *keyChainStoreError;
    [self.keyChainStore synchronizeWithError:&keyChainStoreError];
    
    if (error && keyChainStoreError) {
        *error = [self mapKeyChainStoreError:keyChainStoreError];
    }
    return keyChainStoreError == nil;
}

- (RTError *)mapKeyChainStoreError:(NSError *)error {
    NSInteger code = Unknown;

    if (error && [error.domain isEqualToString:UICKeyChainStoreErrorDomain]) {
        if (error.code == errSecItemNotFound) {
            code = ItemNotFound;
        }
        else if (error.code == errSecDuplicateItem) {
            code = DuplicateItem;
        }
    }
    
    return [RTErrorFactory keyChainErrorWithCode:code
                                   originalError:error];
}

@end
