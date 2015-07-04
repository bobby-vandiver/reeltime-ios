#import "RTLogoutDataManager.h"

#import "RTAPIClient.h"
#import "RTOAuth2TokenStore.h"
#import "RTCurrentUserStore.h"

@interface RTLogoutDataManager ()

@property RTAPIClient *client;
@property RTOAuth2TokenStore *tokenStore;
@property RTCurrentUserStore *currentUserStore;

@end

@implementation RTLogoutDataManager

- (instancetype)initWithClient:(RTAPIClient *)client
                    tokenStore:(RTOAuth2TokenStore *)tokenStore
              currentUserStore:(RTCurrentUserStore *)currentUserStore {

    self = [super init];
    if (self) {
        self.client = client;
        self.tokenStore = tokenStore;
        self.currentUserStore = currentUserStore;
    }
    return self;
}

- (void)revokeCurrentTokenWithSuccess:(NoArgsCallback)success
                              failure:(ErrorCallback)failure {

    NSError *loadUsernameError;
    NSString *username = [self.currentUserStore loadCurrentUsernameWithError:&loadUsernameError];

    failure(loadUsernameError);
    
}

- (void)removeLocalCredentialsWithSuccess:(NoArgsCallback)success
                                  failure:(ErrorCallback)failure {
    
}

@end
