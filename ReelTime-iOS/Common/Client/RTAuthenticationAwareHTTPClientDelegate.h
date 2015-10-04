#import <Foundation/Foundation.h>

#import "RTCallbacks.h"

@class RTAPIClient;

@class RTCurrentUserService;
@class RTLoginWireframe;

@class RTOAuth2TokenRenegotiationStatus;
@class RTOAuth2TokenError;

@interface RTAuthenticationAwareHTTPClientDelegate : NSObject

- (instancetype)initWithAPIClient:(RTAPIClient *)client
               currentUserService:(RTCurrentUserService *)currentUserService
                   loginWireframe:(RTLoginWireframe *)loginWireframe
         tokenRenegotiationStatus:(RTOAuth2TokenRenegotiationStatus *)tokenRenegotiationStatus
               notificationCenter:(NSNotificationCenter *)notificationCenter;

- (NSString *)accessTokenForCurrentUser;

- (void)renegotiateTokenDueToTokenError:(RTOAuth2TokenError *)tokenError
                           withCallback:(NoArgsCallback)callback;

@end
