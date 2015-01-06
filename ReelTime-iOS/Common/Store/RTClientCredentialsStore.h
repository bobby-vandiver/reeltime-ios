#import <Foundation/Foundation.h>

#import "RTClientCredentials.h"
#import "RTKeyChainWrapper.h"

@interface RTClientCredentialsStore : NSObject

- (instancetype)initWithKeyChainWrapper:(RTKeyChainWrapper *)keyChainWrapper;

- (RTClientCredentials *)loadClientCredentialsForUsername:(NSString *)username;

- (BOOL)storeClientCredentials:(RTClientCredentials *)credentials
                   forUsername:(NSString *)username
                         error:(NSError *__autoreleasing *)error;

@end
