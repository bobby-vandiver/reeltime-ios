#import "RTClientCredentials.h"
#import "RTKeyChainWrapper.h"
#import "RTError.h"

@interface RTClientCredentialsStore : NSObject

- (instancetype)initWithKeyChainWrapper:(RTKeyChainWrapper *)keyChainWrapper;

- (RTClientCredentials *)loadClientCredentialsForUsername:(NSString *)username;

- (BOOL)storeClientCredentials:(RTClientCredentials *)credentials
                   forUsername:(NSString *)username
                         error:(RTError *__autoreleasing *)error;

@end
