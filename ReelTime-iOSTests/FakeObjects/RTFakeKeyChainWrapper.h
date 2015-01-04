#import "RTKeyChainWrapper.h"

@interface RTFakeKeyChainWrapper : RTKeyChainWrapper

- (id<NSSecureCoding>)objectForKey:(NSString *)key
                             error:(NSError *__autoreleasing *)error;

- (BOOL)setObject:(id<NSSecureCoding>)object
           forKey:(NSString *)key
            error:(NSError *__autoreleasing *)error;

@end
