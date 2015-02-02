#import "RTClientDelegate.h"

#import "RTCurrentUserStore.h"
#import "RTOAuth2TokenStore.h"

#import "RTOAuth2Token.h"

@interface RTClientDelegate ()

@property RTCurrentUserStore *currentUserStore;
@property RTOAuth2TokenStore *tokenStore;

@end

@implementation RTClientDelegate

- (instancetype)initWithCurrentUserStore:(RTCurrentUserStore *)currentUserStore
                              tokenStore:(RTOAuth2TokenStore *)tokenStore {
    self = [super init];
    if (self) {
        self.currentUserStore = currentUserStore;
        self.tokenStore = tokenStore;
    }
    return self;
}

- (NSString *)accessTokenForCurrentUser {
    NSString *username = [self.currentUserStore loadCurrentUsernameWithError:nil];
    RTOAuth2Token *token = [self.tokenStore loadTokenForUsername:username error:nil];
    return token.accessToken;
}

@end
