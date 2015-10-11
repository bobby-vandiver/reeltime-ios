#import <Foundation/Foundation.h>

#import "RTCallbacks.h"

@class RTAPIClient;

@class RTCurrentUserService;
@class RTLoginWireframe;
@class RTOAuth2TokenRenegotiationStatus;

@interface RTOAuth2TokenRenegotiator : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client
            currentUserService:(RTCurrentUserService *)currentUserService
                loginWireframe:(RTLoginWireframe *)loginWireframe
      tokenRenegotiationStatus:(RTOAuth2TokenRenegotiationStatus *)tokenRenegotiationStatus
            notificationCenter:(NSNotificationCenter *)notificationCenter;

- (void)renegotiateTokenWithCallback:(NoArgsCallback)callback;

@end
