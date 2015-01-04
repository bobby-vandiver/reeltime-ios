#import "RTOAuth2Token.h"
#import "RTKeyChainWrapper.h"
#import "RTError.h"

@interface RTOAuth2TokenStore : NSObject

- (instancetype)initWithKeyChainWrapper:(RTKeyChainWrapper *)keyChainWrapper;

- (RTOAuth2Token *)loadTokenForUsername:(NSString *)username
                                  error:(RTError *__autoreleasing *)error;

- (BOOL)storeToken:(RTOAuth2Token *)token
       forUsername:(NSString *)username
             error:(RTError *__autoreleasing *)error;

@end
