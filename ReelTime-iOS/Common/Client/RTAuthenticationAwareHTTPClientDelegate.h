#import <Foundation/Foundation.h>

@class RTCurrentUserStore;
@class RTOAuth2TokenStore;

@class RTOAuth2TokenError;

@interface RTAuthenticationAwareHTTPClientDelegate : NSObject

- (instancetype)initWithCurrentUserStore:(RTCurrentUserStore *)currentUserStore
                              tokenStore:(RTOAuth2TokenStore *)tokenStore;

- (NSString *)accessTokenForCurrentUser;

- (void)authenticatedRequestFailedWithTokenError:(RTOAuth2TokenError *)tokenError;

@end
