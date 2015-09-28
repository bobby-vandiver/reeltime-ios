#import <Foundation/Foundation.h>

#import "RTCallbacks.h"

@class RTCurrentUserStore;
@class RTOAuth2TokenStore;

@class RTOAuth2TokenError;

@interface RTAuthenticationAwareHTTPClientDelegate : NSObject

- (instancetype)initWithCurrentUserStore:(RTCurrentUserStore *)currentUserStore
                              tokenStore:(RTOAuth2TokenStore *)tokenStore;

- (NSString *)accessTokenForCurrentUser;

- (void)renegotiateTokenDueToTokenError:(RTOAuth2TokenError *)tokenError
                                success:(NoArgsCallback)success
                                failure:(NoArgsCallback)failure;

@end
