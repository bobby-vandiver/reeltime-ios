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
                             error:(RTError *__autoreleasing *)error {
    NSError *loadError;
    NSData *data = [self.keyChainStore dataForKey:key error:&loadError];
    
    if (!data) {
        if (!loadError && error) {
            *error = [RTErrorFactory keyChainErrorWithCode:ItemNotFound originalError:nil];
        }
        else {
            [self mapKeyChainStoreError:loadError toApplicationError:error];
        }
        return nil;
    }
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (BOOL)setObject:(id<NSSecureCoding>)object
           forKey:(NSString *)key
            error:(RTError *__autoreleasing *)error {
    NSError *storeError;
    [self.keyChainStore setData:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:key error:&storeError];

    if (storeError) {
        [self mapKeyChainStoreError:storeError toApplicationError:error];
        return NO;
    }
    
    return [self synchKeyChainStoreWithError:error];
}

- (BOOL)removeObjectForKey:(NSString *)key
                     error:(RTError *__autoreleasing *)error {
    NSError *removeError;
    [self.keyChainStore removeItemForKey:key error:&removeError];
    
    if (removeError) {
        [self mapKeyChainStoreError:removeError toApplicationError:error];
        return NO;
    }
    
    return [self synchKeyChainStoreWithError:error];
}

- (BOOL)synchKeyChainStoreWithError:(RTError *__autoreleasing *)error {
    NSError *synchError;
    [self.keyChainStore synchronizeWithError:&synchError];
    
    if (synchError) {
        [self mapKeyChainStoreError:synchError toApplicationError:error];
        return NO;
    }
    
    return YES;
}

- (void)mapKeyChainStoreError:(NSError *)error
           toApplicationError:(RTError *__autoreleasing *)appError {
    if (appError) {
        NSInteger code = Unknown;
        
        if (error && [error.domain isEqualToString:UICKeyChainStoreErrorDomain]) {
            if (error.code == errSecItemNotFound) {
                code = ItemNotFound;
            }
            else if (error.code == errSecDuplicateItem) {
                code = DuplicateItem;
            }
        }
        
        *appError = [RTErrorFactory keyChainErrorWithCode:code originalError:error];
    }
}

@end
