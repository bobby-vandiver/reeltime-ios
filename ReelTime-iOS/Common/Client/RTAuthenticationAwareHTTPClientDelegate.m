#import "RTAuthenticationAwareHTTPClientDelegate.h"

#import "RTAPIClient.h"
#import "RTCurrentUserService.h"

#import "RTOAuth2Token.h"

#import "RTLogging.h"

static NSString *const RTTokenRenegotiationFinished = @"RTTokenRenegotiationFinished";

@interface RTAuthenticationAwareHTTPClientDelegate ()

@property RTAPIClient *client;
@property RTCurrentUserService *currentUserService;

@property NSLock *renegotiationLock;

@property (nonatomic) BOOL renegotiationInProgress;
@property (nonatomic) BOOL renegotiationSucceeded;

@property (nonatomic) NSInteger renegotiationCounter;

@end

@implementation RTAuthenticationAwareHTTPClientDelegate

- (instancetype)initWithAPIClient:(RTAPIClient *)client
               currentUserService:(RTCurrentUserService *)currentUserService {
    self = [super init];
    if (self) {
        self.client = client;
        self.currentUserService = currentUserService;
        
        self.renegotiationLock = [[NSLock alloc] init];

        self.renegotiationInProgress = NO;
        self.renegotiationSucceeded = NO;
        
        self.renegotiationCounter = 0;
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

    [self incrementCounter];
    
//    __block BOOL renegotiationInProgress = NO;
//    
//    [self performCriticalBlock:^{
//        renegotiationInProgress = self.renegotiationInProgress;
//    }];

    BOOL renegotiationInProgress = [self performCriticalBoolBlock:^BOOL{
        return self.renegotiationInProgress;
    }];
    

    DDLogDebug(@"renegotiationInProgress before branch = %@", (renegotiationInProgress ? @"YES" : @"NO"));
    
    if (renegotiationInProgress) {
        [self waitUntilRenegotiationIsFinished];

//        __block BOOL renegotiationSucceeded;
//    
//        [self performCriticalBlock:^{
//            renegotiationSucceeded = self.renegotiationSucceeded;
//        }];
        
        BOOL renegotiationSucceeded = [self performCriticalBoolBlock:^BOOL{
            return self.renegotiationSucceeded;
        }];
        
        [self decrementCounter];

        if (renegotiationSucceeded) {
            DDLogDebug(@"Waited on successful renegotiation.");
            success();
        }
        else {
            DDLogDebug(@"Waited for failed renegotiation. Depending on failure to kick off recovery mechanism...");
        }
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

- (BOOL)performCriticalBoolBlock:(BOOL (^)())block {
    [self.renegotiationLock lock];
    BOOL result = block();
    [self.renegotiationLock unlock];
    return result;
}

- (void)performCriticalBlock:(void (^)())block {
    [self.renegotiationLock lock];
    block();
    [self.renegotiationLock unlock];
}

- (void)waitUntilRenegotiationIsFinished {
    DDLogDebug(@"waiting until renegotiation is finished...");
    
    BOOL renegotiationInProgress;

    do {
        renegotiationInProgress = [self performCriticalBoolBlock:^{
            return self.renegotiationInProgress;
        }];
        
        if (renegotiationInProgress) {
            DDLogDebug(@"sleeping for one second");
            sleep(1);
        }
        
    } while (renegotiationInProgress);
}

- (void)incrementCounter {
    [self performCriticalBlock:^{
        DDLogDebug(@"incrementing counter");
        self.renegotiationCounter++;
    }];
}

- (void)decrementCounter {
    [self performCriticalBlock:^{
        DDLogDebug(@"decrementing counter");
        self.renegotiationCounter--;
        
        if (self.renegotiationCounter == 0) {
            DDLogDebug(@"Resetting renegotiation tracking variables");
            self.renegotiationSucceeded = NO;
        }
    }];
}

- (void)startRenegotiation {
    [self performCriticalBlock:^{
        DDLogDebug(@"start renegotiation");
        self.renegotiationInProgress = YES;
    }];
}

- (void)renegotiationFinished {
    [self performCriticalBlock:^{
        DDLogDebug(@"renegotiation finished");
        self.renegotiationInProgress = NO;
    }];
}

- (void)renegotiationFinishedSuccessfully {
    [self performCriticalBlock:^{
        DDLogDebug(@"renegotiation finished successfully");
        self.renegotiationInProgress = NO;
        self.renegotiationSucceeded = YES;
    }];
}

- (TokenCallback)tokenSuccessCallbackWithSuccess:(NoArgsCallback)success
                                         failure:(NoArgsCallback)failure {
    return ^(RTOAuth2Token *token) {
        DDLogDebug(@"succesful refresh -- token = %@", token);

        BOOL stored = [self.currentUserService storeTokenForCurrentUser:token];

        if (stored) {
            [self renegotiationFinishedSuccessfully];
            [self decrementCounter];
            
            success();
        }
        else {
            [self renegotiationFinished];
            [self decrementCounter];
            
            failure();
        }
    };
}

- (TokenErrorCallback)tokenFailureCallbackWithFailure:(NoArgsCallback)failure {
    return ^(RTOAuth2TokenError *tokenError) {
        DDLogDebug(@"failed refresh -- token error = %@", tokenError);
        [self decrementCounter];
    };
};

@end
