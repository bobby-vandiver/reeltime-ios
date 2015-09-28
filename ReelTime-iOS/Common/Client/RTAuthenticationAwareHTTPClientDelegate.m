#import "RTAuthenticationAwareHTTPClientDelegate.h"

#import "RTAPIClient.h"
#import "RTCurrentUserService.h"

#import "RTOAuth2Token.h"

@interface RTAuthenticationAwareHTTPClientDelegate ()

@property RTAPIClient *client;
@property RTCurrentUserService *currentUserService;

@end

@implementation RTAuthenticationAwareHTTPClientDelegate

- (instancetype)initWithAPIClient:(RTAPIClient *)client
               currentUserService:(RTCurrentUserService *)currentUserService {
    self = [super init];
    if (self) {
        self.client = client;
        self.currentUserService = currentUserService;
    }
    return self;
}

- (NSString *)accessTokenForCurrentUser {
    RTOAuth2Token *token = [self.currentUserService tokenForCurrentUser];
    return token.accessToken;
}

- (void)renegotiateTokenDueToTokenError:(RTOAuth2TokenError *)tokenError
                                success:(NoArgsCallback)success
                                failure:(NoArgsCallback)failure {
    
    RTOAuth2Token *token = [self.currentUserService tokenForCurrentUser];
    RTClientCredentials *clientCredentials = [self.currentUserService clientCredentialsForCurrentUser];
    
    [self.client refreshToken:token
        withClientCredentials:clientCredentials
                      success:[self tokenSuccessCallbackWithSuccess:success failure:failure]
                      failure:[self tokenFailureCallbackWithFailure:failure]];
}

- (TokenCallback)tokenSuccessCallbackWithSuccess:(NoArgsCallback)success
                                         failure:(NoArgsCallback)failure {
    return ^(RTOAuth2Token *token) {
        BOOL stored = [self.currentUserService storeTokenForCurrentUser:token];
        stored ? success() : failure();
    };
}

- (TokenErrorCallback)tokenFailureCallbackWithFailure:(NoArgsCallback)failure {
    return ^(RTOAuth2TokenError *tokenError) {
        
    };
};

@end
