#import <Foundation/Foundation.h>

#import "RTCallbacks.h"

@class RTCurrentUserService;
@class RTOAuth2TokenError;

@interface RTAuthenticationAwareHTTPClientDelegate : NSObject

- (instancetype)initWithCurrentUserService:(RTCurrentUserService *)currentUserService;

- (NSString *)accessTokenForCurrentUser;

- (void)renegotiateTokenDueToTokenError:(RTOAuth2TokenError *)tokenError
                                success:(NoArgsCallback)success
                                failure:(NoArgsCallback)failure;

@end
