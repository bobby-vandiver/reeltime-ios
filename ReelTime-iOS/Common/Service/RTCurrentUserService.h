#import <Foundation/Foundation.h>

@class RTClientCredentials;
@class RTOAuth2Token;

@class RTCurrentUserStore;
@class RTClientCredentialsStore;
@class RTOAuth2TokenStore;

@interface RTCurrentUserService : NSObject

- (instancetype)initWithCurrentUserStore:(RTCurrentUserStore *)currentUserStore
                  clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore
                              tokenStore:(RTOAuth2TokenStore *)tokenStore;

- (NSString *)currentUsername;

- (RTClientCredentials *)clientCredentialsForCurrentUser;

- (RTOAuth2Token *)tokenForCurrentUser;

@end
