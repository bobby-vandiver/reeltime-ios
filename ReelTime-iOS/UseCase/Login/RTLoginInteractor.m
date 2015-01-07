#import "RTLoginInteractor.h"
#import "RTLoginPresenter.h"
#import "RTLoginDataManager.h"

#import "RTLoginErrors.h"
#import "RTClientErrors.h"

#import "RTErrorFactory.h"

@interface RTLoginInteractor ()

@property RTLoginPresenter *presenter;
@property RTLoginDataManager *dataManager;
@property RTClient *client;

@end

@implementation RTLoginInteractor

- (instancetype)initWithPresenter:(RTLoginPresenter *)presenter
                      dataManager:(RTLoginDataManager *)dataManager
                           client:(RTClient *)client {
    self = [super init];
    if (self) {
        self.presenter = presenter;
        self.dataManager = dataManager;
        self.client = client;
    }
    return self;
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password {
    RTClientCredentials *clientCredentials = [self.dataManager clientCredentialsForUsername:username];

    if (!clientCredentials) {
        [self loginFailedWithErrorCode:UnknownClient];
    }
    else {
        RTUserCredentials *userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                                                password:password];
        [self.client tokenWithClientCredentials:clientCredentials
                                userCredentials:userCredentials
                                        success:[self loginSucceededForUsername:username]
                                        failure:[self loginFailed]];
    }
}

- (TokenSuccessHandler)loginSucceededForUsername:(NSString *)username {
    return ^(RTOAuth2Token *token) {
        NSError *error;
        BOOL success = [self.dataManager rememberToken:token
                                           forUsername:username
                                                 error:&error];
        
        if (success) {
            success = [self.dataManager setCurrentlyLoggedInUsername:username error:&error];

            if (!success) {
                [self.dataManager forgetTokenForUsername:username error:&error];
            }
        }
        
        if (success) {
            [self.presenter loginSucceeded];
        }
        else {
            [self.presenter loginFailedWithError:error];
        }
    };
}

- (TokenFailureHandler)loginFailed {
    return ^(NSError *error) {
        if (![error.domain isEqualToString:RTClientTokenErrorDomain]) {
            [self.presenter loginFailedWithError:error];
        }
        
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
