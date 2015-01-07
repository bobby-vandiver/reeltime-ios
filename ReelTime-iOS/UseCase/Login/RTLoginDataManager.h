#import <Foundation/Foundation.h>

#import "RTClientCredentialsStore.h"
#import "RTOAuth2TokenStore.h"
#import "RTCurrentUserStore.h"

@interface RTLoginDataManager : NSObject

- (instancetype)initWithClientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore
                                    tokenStore:(RTOAuth2TokenStore *)tokenStore
                              currentUserStore:(RTCurrentUserStore *)currentUserStore;

- (RTClientCredentials *)clientCredentialsForUsername:(NSString *)username;

- (BOOL)rememberToken:(RTOAuth2Token *)token
          forUsername:(NSString *)username
                error:(NSError *__autoreleasing *)error;

- (BOOL)forgetTokenForUsername:(NSString *)username
                         error:(NSError *__autoreleasing *)error;

- (BOOL)setCurrentlyLoggedInUsername:(NSString *)username
                               error:(NSError *__autoreleasing *)error;

@end
