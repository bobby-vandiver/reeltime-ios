#import "RTLoginInteractor.h"
#import "RTLoginPresenter.h"

#import "RTLoginErrors.h"
#import "RTClientErrors.h"

#import "RTErrorFactory.h"

@interface RTLoginInteractor ()

@property RTLoginPresenter *presenter;
@property RTClient *client;
@property RTClientCredentialsStore *clientCredentialsStore;
@property RTOAuth2TokenStore *tokenStore;
@property RTCurrentUserStore *currentUserStore;

@end

@implementation RTLoginInteractor

- (instancetype)initWithPresenter:(RTLoginPresenter *)presenter
                           client:(RTClient *)client
           clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore
                       tokenStore:(RTOAuth2TokenStore *)tokenStore
                 currentUserStore:(RTCurrentUserStore *)currentUserStore {
    self = [super init];
    if (self) {
        self.presenter = presenter;
        self.client = client;
        self.clientCredentialsStore = clientCredentialsStore;
        self.tokenStore = tokenStore;
        self.currentUserStore = currentUserStore;
    }
    return self;
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password {
    RTClientCredentials *clientCredentials = [self.clientCredentialsStore loadClientCredentialsForUsername:username];

    if (!clientCredentials) {
        [self loginFailedWithErrorCode:UnknownClient];
    }
    else {
        RTUserCredentials *userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                                                password:password];
        [self.client tokenWithClientCredentials:clientCredentials
                                userCredentials:userCredentials
                                        success:[self loginSuccededForUsername:username]
                                        failure:[self loginFailed]];
    }
}

- (TokenSuccessHandler)loginSuccededForUsername:(NSString *)username {
    return ^(RTOAuth2Token *token) {
        NSError *tokenStoreError;
        BOOL storeSucceded = [self.tokenStore storeToken:token
                                             forUsername:username
                                                   error:&tokenStoreError];
        
        if (storeSucceded) {
            NSError *currentUserError;
            BOOL setCurrentUserSucceeded = [self.currentUserStore storeCurrentUsername:username
                                                                                 error:&currentUserError];

            if (setCurrentUserSucceeded) {
                [self.presenter loginSucceeded];
            }
            else {
                [self.tokenStore removeTokenForUsername:username error:&tokenStoreError];
                [self.presenter loginFailedWithError:currentUserError];
            }
        }
        else {
            [self.presenter loginFailedWithError:tokenStoreError];
        }
    };
}

- (TokenFailureHandler)loginFailed {
    return ^(NSError *error) {
        NSInteger errorCode;
        
        if (error.code == InvalidClientCredentials) {
            errorCode = UnknownClient;
        }
        else if (error.code == InvalidUserCredentials) {
            errorCode = InvalidCredentials;
        }
        
        [self loginFailedWithErrorCode:errorCode];
    };
}

- (void)loginFailedWithErrorCode:(RTLoginErrors)code {
    NSError *loginError = [RTErrorFactory loginErrorWithCode:code];
    [self.presenter loginFailedWithError:loginError];
}

@end
