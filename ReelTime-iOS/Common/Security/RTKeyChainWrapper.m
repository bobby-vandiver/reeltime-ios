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
    if (![self validateKey:key error:error]) {
        return nil;
    }
    
    NSError *loadError;
    NSData *data = [self.keyChainStore dataForKey:key error:&loadError];
    
    if (!data) {
        if (!loadError && error) {
            *error = [RTErrorFactory keyChainErrorWithCode:RTKeyChainErrorItemNotFound originalError:nil];
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
            error:(NSError *__autoreleasing *)error {
    if (![self validateKey:key error:error]) {
        return NO;
    }
    
    NSError *storeError;
    BOOL success = [self.keyChainStore setData:[NSKeyedArchiver archivedDataWithRootObject:object]
                                        forKey:key
                                         error:&storeError];

    if (!success) {
        [self mapKeyChainStoreError:storeError toApplicationError:error];
    }
    
    return success;
}

- (BOOL)removeObjectForKey:(NSString *)key
                     error:(NSError *__autoreleasing *)error {
    if (![self validateKey:key error:error]) {
        return NO;
    }
    
    NSError *removeError;
    BOOL success = [self.keyChainStore removeItemForKey:key error:&removeError];
    
    if (!success) {
        [self mapKeyChainStoreError:removeError toApplicationError:error];
    }
    
    return success;
}

- (BOOL)validateKey:(NSString *)key
              error:(NSError *__autoreleasing *)error {
    BOOL valid = YES;
    
    if (!key) {
        valid = NO;

        if (error) {
            *error = [RTErrorFactory keyChainErrorWithCode:RTKeyChainErrorMissingKey originalError:nil];
        }
    }
    
    return valid;
}

- (void)mapKeyChainStoreError:(NSError *)error
           toApplicationError:(NSError *__autoreleasing *)appError {
    if (appError) {
        NSInteger code = RTKeyChainErrorUnknown;
        
        if (error && [error.domain isEqualToString:UICKeyChainStoreErrorDomain]) {
            if (error.code == errSecItemNotFound) {
                code = RTKeyChainErrorItemNotFound;
            }
            else if (error.code == errSecDuplicateItem) {
                code = RTKeyChainErrorDuplicateItem;
            }
        }
        
        *appError = [RTErrorFactory keyChainErrorWithCode:code originalError:error];
    }
}

@end
