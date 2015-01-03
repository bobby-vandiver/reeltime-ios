#import <UICKeyChainStore/UICKeyChainStore.h>
#import "RTClientCredentials.h"

@interface RTClientCredentialsStore : NSObject

- (instancetype)initWithKeyChainStore:(UICKeyChainStore *)keyChainStore;

- (RTClientCredentials *)loadClientCredentialsForUsername:(NSString *)username;

- (BOOL)storeClientCredentials:(RTClientCredentials *)credentials
                   forUsername:(NSString *)username
                         error:(NSError *__autoreleasing *)error;

@end
