#import "RTAuthenticationAwareHTTPClientDelegate.h"

#import "RTAPIClient.h"

#import "RTCurrentUserService.h"
#import "RTLoginWireframe.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenRenegotiationStatus.h"

#import "RTLogging.h"

@interface RTAuthenticationAwareHTTPClientDelegate ()

@property RTAPIClient *client;

@property RTCurrentUserService *currentUserService;
@property RTLoginWireframe *loginWireframe;

@property RTOAuth2TokenRenegotiationStatus *tokenRenegotiationStatus;

@end

@implementation RTAuthenticationAwareHTTPClientDelegate

- (instancetype)initWithAPIClient:(RTAPIClient *)client
               currentUserService:(RTCurrentUserService *)currentUserService
                   loginWireframe:(RTLoginWireframe *)loginWireframe {
    self = [super init];
    if (self) {
        self.client = client;

        self.currentUserService = currentUserService;
        self.loginWireframe = loginWireframe;

        self.tokenRenegotiationStatus = [[RTOAuth2TokenRenegotiationStatus alloc] init];
    }
    return self;
}


- (NSString *)accessTokenForCurrentUser {
    RTOAuth2Token *token = [self.currentUserService tokenForCurrentUser];
    return token.accessToken;
}

- (void)renegotiateTokenDueToTokenError:(RTOAuth2TokenError *)tokenError
                           withCallback:(NoArgsCallback)callback {
    
    DDLogDebug(@"entering renegotiateTokenDueToTokenError:success:failure");

    RTOAuth2TokenRenegotiationStatus *status = self.tokenRenegotiationStatus;
    
    if (status.renegotiationInProgress) {
        
        [status waitUntilRenegotiationIsFinished:^{
            if (status.lastRenegotiationSucceeded) {
                DDLogDebug(@"Waited on successful renegotiation.");
                callback();
            }
            else {
                DDLogDebug(@"Waited for failed renegotiation. Depending on failure to kick off recovery mechanism...");
            }
        }];
    }
    else {
        [status renegotiationStarted];
        
        RTOAuth2Token *token = [self.currentUserService tokenForCurrentUser];
        RTClientCredentials *clientCredentials = [self.currentUserService clientCredentialsForCurrentUser];
        
        [self.client refreshToken:token
            withClientCredentials:clientCredentials
                          success:[self tokenSuccessCallbackWithCallback:callback]
                          failure:[self tokenFailureCallbackWithCallback:callback]];
    }
}

- (TokenCallback)tokenSuccessCallbackWithCallback:(NoArgsCallback)callback {
    return ^(RTOAuth2Token *token) {
        DDLogDebug(@"successful refresh -- token = %@", token);
        
        BOOL success = [self.currentUserService storeTokenForCurrentUser:token];
        [self.tokenRenegotiationStatus renegotiationFinished:success];
        
        if (success) {
            callback();
        }
    };
}

- (TokenErrorCallback)tokenFailureCallbackWithCallback:(NoArgsCallback)callback {
    return ^(RTOAuth2TokenError *tokenError) {
        DDLogDebug(@"failed refresh -- token error = %@", tokenError);
        [self.loginWireframe presentReloginInterface];
        [self.tokenRenegotiationStatus renegotiationFinished:NO];
    };
};

@end
