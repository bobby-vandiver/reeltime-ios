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
    
}

@end
