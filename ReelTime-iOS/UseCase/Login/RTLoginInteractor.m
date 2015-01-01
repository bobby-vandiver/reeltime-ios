#import "RTLoginInteractor.h"
#import "RTLoginPresenter.h"

#import "RTLoginErrors.h"
#import "RTClientErrors.h"

#import "NSError+RTErrorFactory.h"

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
    RTClientCredentials *clientCredentials = [self.clientCredentialsStore loadClientCredentials];

    if (!clientCredentials) {
        [self loginFailedWithErrorCode:UnknownClient];
    }
    else {
        RTUserCredentials *userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                                                password:password];
        [self.client tokenWithClientCredentials:clientCredentials
                                userCredentials:userCredentials
                                        success:[self loginSucceded]
                                        failure:[self loginFailed]];
    }
}

- (TokenSuccessHandler)loginSucceded {
    return ^(RTOAuth2Token *token) {
        NSError *tokenStoreError;
        BOOL storeSucceded = [self.tokenStore storeToken:token error:&tokenStoreError];
        
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
    NSError *loginError = [NSError rt_loginErrorWithCode:code];
    [self.presenter loginFailedWithError:loginError];
}

@end
