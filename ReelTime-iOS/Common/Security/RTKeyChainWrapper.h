#import <Foundation/Foundation.h>
#import <UICKeyChainStore/UICKeyChainStore.h>

@interface RTKeyChainWrapper : NSObject

- (instancetype)initWithKeyChainStore:(UICKeyChainStore *)keyChainStore;

- (NSData *)dataForKey:(NSString *)key
                 error:(NSError *__autoreleasing *)error;

- (void)setData:(NSData *)data
         forKey:(NSString *)key
          error:(NSError *__autoreleasing *)error;

@end
