#import "RTLoginDataManager.h"
#import "RTErrorFactory.h"

@interface RTLoginDataManager ()

@property RTClientCredentialsStore *clientCredentialsStore;
@property RTOAuth2TokenStore *tokenStore;
@property RTCurrentUserStore *currentUserStore;

@end

@implementation RTLoginDataManager

- (instancetype)initWithClientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore
                                    tokenStore:(RTOAuth2TokenStore *)tokenStore
                              currentUserStore:(RTCurrentUserStore *)currentUserStore {
    self = [super init];
    if (self) {
        self.clientCredentialsStore = clientCredentialsStore;
        self.tokenStore = tokenStore;
        self.currentUserStore = currentUserStore;
    }
    return self;
}

- (RTClientCredentials *)clientCredentialsForUsername:(NSString *)username {
    return [self.clientCredentialsStore loadClientCredentialsForUsername:username];
}

- (BOOL)rememberToken:(RTOAuth2Token *)token
          forUsername:(NSString *)username
                error:(NSError *__autoreleasing *)error {
    NSError *storeError;
    BOOL success = [self.tokenStore storeToken:token forUsername:username error:&storeError];
    
    if (!success && error) {
        *error = [RTErrorFactory loginErrorWithCode:UnableToStoreToken originalError:storeError];
    }
    
    return success;
}

- (BOOL)forgetTokenForUsername:(NSString *)username
                         error:(NSError *__autoreleasing *)error {
    NSError *storeError;
    BOOL success = [self.tokenStore removeTokenForUsername:username error:&storeError];
    
    if (!success && error) {
        *error = [RTErrorFactory loginErrorWithCode:UnableToRemoveToken originalError:storeError];
    }
    
    return success;
}

- (BOOL)setCurrentlyLoggedInUsername:(NSString *)username
                               error:(NSError *__autoreleasing *)error {
    NSError *storeError;
    BOOL success = [self.currentUserStore storeCurrentUsername:username error:&storeError];
    
    if (!success && error) {
        *error = [RTErrorFactory loginErrorWithCode:UnableToSetCurrentlyLoggedInUser originalError:storeError];
    }
    
    return success;
}

@end
