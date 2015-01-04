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

@end

@implementation RTLoginInteractor

- (instancetype)initWithPresenter:(RTLoginPresenter *)presenter
                           client:(RTClient *)client
           clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore
                       tokenStore:(RTOAuth2TokenStore *)tokenStore {
    self = [super init];
    if (self) {
        self.presenter = presenter;
        self.client = client;
        self.clientCredentialsStore = clientCredentialsStore;
        self.tokenStore = tokenStore;
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
        RTError *tokenStoreError;
        BOOL storeSucceded = [self.tokenStore storeToken:token
                                             forUsername:username
                                                   error:&tokenStoreError];
        
        if (storeSucceded) {
            [self.presenter loginSucceeded];
        }
        else {
            // TODO: Handle token storage errors
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
    RTError *loginError = [RTErrorFactory loginErrorWithCode:code];
    [self.presenter loginFailedWithError:loginError];
}

@end
