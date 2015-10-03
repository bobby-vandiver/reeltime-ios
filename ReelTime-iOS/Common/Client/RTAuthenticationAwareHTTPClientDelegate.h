#import <Foundation/Foundation.h>

#import "RTCallbacks.h"

@class RTAPIClient;

@class RTCurrentUserService;
@class RTLoginWireframe;

@class RTOAuth2TokenError;

@interface RTAuthenticationAwareHTTPClientDelegate : NSObject

- (instancetype)initWithAPIClient:(RTAPIClient *)client
               currentUserService:(RTCurrentUserService *)currentUserService
                   loginWireframe:(RTLoginWireframe *)loginWireframe;

- (NSString *)accessTokenForCurrentUser;

- (void)renegotiateTokenDueToTokenError:(RTOAuth2TokenError *)tokenError
                           withCallback:(NoArgsCallback)callback;

@end
