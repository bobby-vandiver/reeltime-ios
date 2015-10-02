#import "RTAuthenticationAwareHTTPClientDelegate.h"

#import "RTAPIClient.h"
#import "RTCurrentUserService.h"

#import "RTOAuth2Token.h"

#import "RTLogging.h"

static NSString *const RTTokenRenegotiationFinished = @"RTTokenRenegotiationFinished";

@interface RTAuthenticationAwareHTTPClientDelegate ()

@property RTAPIClient *client;
@property RTCurrentUserService *currentUserService;

@property NSCondition *condition;

@property (nonatomic) BOOL renegotiationInProgress;
@property (nonatomic) BOOL renegotiationSucceeded;

@end

@implementation RTAuthenticationAwareHTTPClientDelegate

- (instancetype)initWithAPIClient:(RTAPIClient *)client
               currentUserService:(RTCurrentUserService *)currentUserService {
    self = [super init];
    if (self) {
        self.client = client;
        self.currentUserService = currentUserService;
        
        self.condition = [[NSCondition alloc] init];
        
        self.renegotiationInProgress = NO;
        self.renegotiationSucceeded = NO;
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
    
    DDLogDebug(@"entering renegotiateTokenDueToTokenError:success:failure");
    
    [self.condition lock];
    BOOL renegotiationInProgress = self.renegotiationInProgress;
    [self.condition unlock];
    
    DDLogDebug(@"renegotiationInProgress before branch = %@", (renegotiationInProgress ? @"YES" : @"NO"));
    
    if (renegotiationInProgress) {
        [self waitUntilRenegotiationIsFinished:^{
            
            [self.condition lock];
            BOOL renegotiationSucceeded = self.renegotiationSucceeded;
            [self.condition unlock];
            
            if (renegotiationSucceeded) {
                DDLogDebug(@"Waited on successful renegotiation.");
                success();
            }
            else {
                DDLogDebug(@"Waited for failed renegotiation. Depending on failure to kick off recovery mechanism...");
            }
        }];
    }
    else {
        [self startRenegotiation];
        
        RTOAuth2Token *token = [self.currentUserService tokenForCurrentUser];
        RTClientCredentials *clientCredentials = [self.currentUserService clientCredentialsForCurrentUser];
        
        [self.client refreshToken:token
            withClientCredentials:clientCredentials
                          success:[self tokenSuccessCallbackWithSuccess:success failure:failure]
                          failure:[self tokenFailureCallbackWithFailure:failure]];
    }
}

- (void)waitUntilRenegotiationIsFinished:(NoArgsCallback)callback {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.condition lock];
        
        DDLogDebug(@"waiting until renegotiation is finished...");
        
        while (self.renegotiationInProgress) {
            [self.condition wait];
        }
        
        [self.condition unlock];
        
        callback();
    });
}

- (void)startRenegotiation {
    [self.condition lock];
    
    DDLogDebug(@"start renegotiation");
    self.renegotiationInProgress = YES;
    
    [self.condition unlock];
}

- (void)renegotiationFinished:(BOOL)success {
    [self.condition lock];
    
    DDLogDebug(@"@renegotiation finished -- success = %@", (success ? @"YES" : @"NO"));
    
    self.renegotiationInProgress = NO;
    self.renegotiationSucceeded = success;
    
    [self.condition signal];
    [self.condition unlock];
}

- (TokenCallback)tokenSuccessCallbackWithSuccess:(NoArgsCallback)success
                                         failure:(NoArgsCallback)failure {
    return ^(RTOAuth2Token *token) {
        DDLogDebug(@"succesful refresh -- token = %@", token);
        
        BOOL stored = [self.currentUserService storeTokenForCurrentUser:token];
        
        [self renegotiationFinished:stored];
        
        stored ? success() : failure();
    };
}

- (TokenErrorCallback)tokenFailureCallbackWithFailure:(NoArgsCallback)failure {
    return ^(RTOAuth2TokenError *tokenError) {
        DDLogDebug(@"failed refresh -- token error = %@", tokenError);
        [self renegotiationFinished:NO];
    };
};

@end
