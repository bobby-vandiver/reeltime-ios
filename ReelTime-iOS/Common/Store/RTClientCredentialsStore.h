#import <UICKeyChainStore/UICKeyChainStore.h>
#import "RTClientCredentials.h"

@interface RTClientCredentialsStore : NSObject

- (instancetype)initWithKeyChainStore:(UICKeyChainStore *)keyChainStore;

- (RTClientCredentials *)loadClientCredentials;

@end
