#import "RTLoginDataManager.h"

#import "RTLoginInteractor.h"
#import "RTLoginInteractor+RTLoginDataManagerDelegate.h"

#import "RTErrorFactory.h"

@interface RTLoginDataManager ()

@property RTLoginInteractor *interactor;
@property RTClient *client;
@property RTClientCredentialsStore *clientCredentialsStore;
@property RTOAuth2TokenStore *tokenStore;
@property RTCurrentUserStore *currentUserStore;

@end

@implementation RTLoginDataManager

- (instancetype)initWithInteractor:(RTLoginInteractor *)interactor
                            client:(RTClient *)client
            clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore
                        tokenStore:(RTOAuth2TokenStore *)tokenStore
                  currentUserStore:(RTCurrentUserStore *)currentUserStore {
    self = [super init];
    if (self) {
        self.interactor = interactor;
        self.client = client;
        self.clientCredentialsStore = clientCredentialsStore;
        self.tokenStore = tokenStore;
        self.currentUserStore = currentUserStore;
    }
    return self;
}

- (RTClientCredentials *)clientCredentialsForUsername:(NSString *)username {
    return [self.clientCredentialsStore loadClientCredentialsForUsername:username];
}

- (void)fetchTokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                        userCredentials:(RTUserCredentials *)userCredentials
                               callback:(void (^)(RTOAuth2Token *, NSString *))callback {
    NSString *username = userCredentials.username;
    
    TokenSuccessHandler success = ^(RTOAuth2Token *token) {
        callback(token, username);
    };
    
    TokenFailureHandler failure = ^(NSError *error) {
        [self.interactor loginDataOperationFailedWithError:error];
    };
    
    [self.client tokenWithClientCredentials:clientCredentials
                            userCredentials:userCredentials
                                    success:success
                                    failure:failure];
}

- (void)setLoggedInUserWithToken:(RTOAuth2Token *)token
                        username:(NSString *)username {
    NSError *error;
    BOOL success = [self saveToken:token forUsername:username error:&error];
    
    if (success) {
        success = [self setCurrentlyLoggedInUserForUsername:username error:&error];
        
        if (!success) {
            [self deleteTokenForUsername:username error:&error];
        }
    }
    
    if (success) {
        [self.interactor didSetLoggedInUser];
    }
    else {
        [self.interactor loginDataOperationFailedWithError:error];
    }
}

- (BOOL)saveToken:(RTOAuth2Token *)token
      forUsername:(NSString *)username
            error:(NSError *__autoreleasing *)error {
    NSError *storeError;
    BOOL success = [self.tokenStore storeToken:token forUsername:username error:&storeError];
    
    if (!success && error) {
        *error = [RTErrorFactory loginErrorWithCode:LoginUnableToStoreToken originalError:storeError];
    }
    
    return success;
}

- (BOOL)setCurrentlyLoggedInUserForUsername:(NSString *)username
                                      error:(NSError *__autoreleasing *)error {
    NSError *storeError;
    BOOL success = [self.currentUserStore storeCurrentUsername:username error:&storeError];
    
    if (!success && error) {
        *error = [RTErrorFactory loginErrorWithCode:LoginUnableToSetCurrentlyLoggedInUser
                                              originalError:storeError];
    }
    
    return success;
}

- (BOOL)deleteTokenForUsername:(NSString *)username
                         error:(NSError *__autoreleasing *)error {
    NSError *storeError;
    BOOL success = [self.tokenStore removeTokenForUsername:username error:&storeError];
    
    if (!success && error) {
        *error = [RTErrorFactory loginErrorWithCode:LoginUnableToRemoveToken originalError:storeError];
    }
    
    return success;
}


@end
