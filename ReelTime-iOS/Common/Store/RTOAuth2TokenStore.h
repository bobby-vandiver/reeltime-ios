#import "RTOAuth2Token.h"
#import "RTKeyChainWrapper.h"

@interface RTOAuth2TokenStore : NSObject

- (instancetype)initWithKeyChainWrapper:(RTKeyChainWrapper *)keyChainWrapper;

- (RTOAuth2Token *)loadTokenForUsername:(NSString *)username
                                  error:(NSError *__autoreleasing *)outError;

- (BOOL)storeToken:(RTOAuth2Token *)token
       forUsername:(NSString *)username
             error:(NSError *__autoreleasing *)outError;

@end
