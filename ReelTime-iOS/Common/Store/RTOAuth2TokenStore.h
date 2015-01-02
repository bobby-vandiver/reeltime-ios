#import <UICKeyChainStore/UICKeyChainStore.h>
#import "RTOAuth2Token.h"

@interface RTOAuth2TokenStore : NSObject

- (instancetype)initWithKeyChainStore:(UICKeyChainStore *)keyChainStore;

- (BOOL)storeToken:(RTOAuth2Token *)token
          username:(NSString *)username
             error:(NSError *__autoreleasing *)outError;

@end
