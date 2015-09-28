#import <Foundation/Foundation.h>

#import "RTCallbacks.h"

@class RTAPIClient;
@class RTCurrentUserService;

@class RTOAuth2TokenError;

@interface RTAuthenticationAwareHTTPClientDelegate : NSObject

- (instancetype)initWithAPIClient:(RTAPIClient *)client
               currentUserService:(RTCurrentUserService *)currentUserService;

- (NSString *)accessTokenForCurrentUser;

- (void)renegotiateTokenDueToTokenError:(RTOAuth2TokenError *)tokenError
                                success:(NoArgsCallback)success
                                failure:(NoArgsCallback)failure;

@end
