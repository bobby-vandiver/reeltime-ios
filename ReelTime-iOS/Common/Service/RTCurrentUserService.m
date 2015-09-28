#import "RTCurrentUserService.h"
#import "RTCurrentUserStore.h"

#import "RTClientCredentials.h"
#import "RTClientCredentialsStore.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenStore.h"

#import "RTLogging.h"

@interface RTCurrentUserService ()

@property RTCurrentUserStore *currentUserStore;
@property RTClientCredentialsStore *clientCredentialsStore;
@property RTOAuth2TokenStore *tokenStore;

@end

@implementation RTCurrentUserService

- (instancetype)initWithCurrentUserStore:(RTCurrentUserStore *)currentUserStore
                  clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore
                              tokenStore:(RTOAuth2TokenStore *)tokenStore {
    self = [super init];
    if (self) {
        self.currentUserStore = currentUserStore;
        self.clientCredentialsStore = clientCredentialsStore;
        self.tokenStore = tokenStore;
    }
    return self;
}

- (NSString *)currentUsername {
    NSError *error;
    NSString *username = [self.currentUserStore loadCurrentUsernameWithError:&error];

    if (!username) {
        DDLogDebug(@"Could not load current username: %@", error);
    }
    
    return username;
}

- (RTClientCredentials *)clientCredentialsForCurrentUser {
    NSString *username = [self currentUsername];
    if (!username) {
        return nil;
    }
    
    NSError *error;
    RTClientCredentials *clientCredentials = [self.clientCredentialsStore loadClientCredentialsForUsername:username error:&error];
    
    if (!clientCredentials) {
        DDLogDebug(@"Could not load client credentials for current username: %@", error);
    }
    
    return clientCredentials;
}

- (RTOAuth2Token *)tokenForCurrentUser {
    NSString *username = [self currentUsername];
    if (!username) {
        return nil;
    }
    
    NSError *error;
    RTOAuth2Token *token = [self.tokenStore loadTokenForUsername:username error:&error];
    
    if (!token) {
        DDLogDebug(@"Could not load token for current username: %@", error);
    }
    
    return token;
}

- (BOOL)storeTokenForCurrentUser:(RTOAuth2Token *)token {
    NSString *username = [self currentUsername];
    if (!username) {
        return NO;
    }
    
    NSError *error;
    BOOL success = [self.tokenStore storeToken:token forUsername:username error:&error];
    
    if (!success) {
        DDLogWarn(@"Could not store token for current username: %@", error);
    }
    
    return success;
}

@end
