#import <Foundation/Foundation.h>
#import <UICKeyChainStore/UICKeyChainStore.h>

@interface RTKeyChainWrapper : NSObject

- (instancetype)initWithKeyChainStore:(UICKeyChainStore *)keyChainStore;

- (id<NSCoding>)objectForKey:(NSString *)key
                       error:(NSError *__autoreleasing *)error;

- (void)setObject:(id<NSCoding>)object
           forKey:(NSString *)key
            error:(NSError *__autoreleasing *)error;

@end
