#import "RTLoginDataManager.h"
#import "RTLoginDataManagerDelegate.h"

#import "RTClient.h"
#import "RTClientCredentialsStore.h"

#import "RTOAuth2TokenStore.h"
#import "RTCurrentUserStore.h"

#import "RTUserCredentials.h"
#import "RTClientCredentials.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenError.h"

#import "RTErrorFactory.h"

@interface RTLoginDataManager ()

@property (weak) id<RTLoginDataManagerDelegate> delegate;
@property RTClient *client;
@property RTClientCredentialsStore *clientCredentialsStore;
@property RTOAuth2TokenStore *tokenStore;
@property RTCurrentUserStore *currentUserStore;

@end

@implementation RTLoginDataManager

- (instancetype)initWithDelegate:(id<RTLoginDataManagerDelegate>)delegate
                          client:(RTClient *)client
          clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore
                      tokenStore:(RTOAuth2TokenStore *)tokenStore
                currentUserStore:(RTCurrentUserStore *)currentUserStore {
    self = [super init];
    if (self) {
        self.delegate = delegate;
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
                               callback:(TokenAndUsernameCallback)callback {
    NSString *username = userCredentials.username;
    
    id success = ^(RTOAuth2Token *token) {
        callback(token, username);
    };
    
    id failure = ^(RTOAuth2TokenError *tokenError) {
        RTLoginError loginErrorCode;
        NSString *errorCode = tokenError.errorCode;
        	
        if ([errorCode isEqualToString:@"invalid_client"]) {
            loginErrorCode = RTLoginErrorUnknownClient;
        }
        else if ([errorCode isEqualToString:@"invalid_grant"]) {
            loginErrorCode = RTLoginErrorInvalidCredentials;
        }
        else {
            loginErrorCode = RTLoginErrorUnknownTokenError;
        }

        NSError *error = [RTErrorFactory loginErrorWithCode:loginErrorCode];
        [self.delegate loginDataOperationFailedWithError:error];
    };
    
    [self.client tokenWithClientCredentials:clientCredentials
                            userCredentials:userCredentials
                                    success:success
                                    failure:failure];
}

- (void)setLoggedInUserWithToken:(RTOAuth2Token *)token
                        username:(NSString *)username
                        callback:(NoArgsCallback)callback {
    NSError *error;
    BOOL success = [self saveToken:token forUsername:username error:&error];
    
    if (success) {
        success = [self setCurrentlyLoggedInUserForUsername:username error:&error];
        
        if (!success) {
            [self deleteTokenForUsername:username error:&error];
        }
    }
    
    if (success) {
        callback();
    }
    else {
        [self.delegate loginDataOperationFailedWithError:error];
    }
}

- (BOOL)saveToken:(RTOAuth2Token *)token
      forUsername:(NSString *)username
            error:(NSError *__autoreleasing *)error {
    NSError *storeError;
    BOOL success = [self.tokenStore storeToken:token forUsername:username error:&storeError];
    
    if (!success && error) {
        *error = [RTErrorFactory loginErrorWithCode:RTLoginErrorUnableToStoreToken originalError:storeError];
    }
    
    return success;
}

- (BOOL)setCurrentlyLoggedInUserForUsername:(NSString *)username
                                      error:(NSError *__autoreleasing *)error {
    NSError *storeError;
    BOOL success = [self.currentUserStore storeCurrentUsername:username error:&storeError];
    
    if (!success && error) {
        *error = [RTErrorFactory loginErrorWithCode:RTLoginErrorUnableToSetCurrentlyLoggedInUser
                                              originalError:storeError];
    }
    
    return success;
}

- (BOOL)deleteTokenForUsername:(NSString *)username
                         error:(NSError *__autoreleasing *)error {
    NSError *storeError;
    BOOL success = [self.tokenStore removeTokenForUsername:username error:&storeError];
    
    if (!success && error) {
        *error = [RTErrorFactory loginErrorWithCode:RTLoginErrorUnableToRemoveToken originalError:storeError];
    }
    
    return success;
}


@end
