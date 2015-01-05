#import <Foundation/Foundation.h>
#import <UICKeyChainStore/UICKeyChainStore.h>

#import "RTError.h"

@interface RTKeyChainWrapper : NSObject

- (instancetype)initWithKeyChainStore:(UICKeyChainStore *)keyChainStore;

- (id<NSSecureCoding>)objectForKey:(NSString *)key
                             error:(RTError *__autoreleasing *)error;

- (BOOL)setObject:(id<NSSecureCoding>)object
           forKey:(NSString *)key
            error:(RTError *__autoreleasing *)error;

- (BOOL)removeObjectForKey:(NSString *)key
                     error:(RTError *__autoreleasing *)error;

@end
