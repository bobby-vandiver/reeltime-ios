#import <Foundation/Foundation.h>
#import <UICKeyChainStore/UICKeyChainStore.h>

@interface RTKeyChainWrapper : NSObject

- (instancetype)initWithKeyChainStore:(UICKeyChainStore *)keyChainStore;

- (id<NSSecureCoding>)objectForKey:(NSString *)key
                             error:(NSError *__autoreleasing *)error;

- (BOOL)setObject:(id<NSSecureCoding>)object
           forKey:(NSString *)key
            error:(NSError *__autoreleasing *)error;

- (BOOL)removeObjectForKey:(NSString *)key
                     error:(NSError *__autoreleasing *)error;

@end
