#import "RTLoginInteractor.h"
#import "RTLoginInteractor+RTLoginDataManagerDelegate.h"

#import "RTLoginPresenter.h"
#import "RTLoginDataManager.h"

#import "RTLoginErrors.h"
#import "RTClientErrors.h"

#import "RTErrorFactory.h"

@interface RTLoginInteractor ()

@property RTLoginPresenter *presenter;
@property RTLoginDataManager *dataManager;

@end

@implementation RTLoginInteractor

- (instancetype)initWithPresenter:(RTLoginPresenter *)presenter
                      dataManager:(RTLoginDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.presenter = presenter;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password {
    if ([username length] == 0) {
        [self loginFailedWithErrorCode:LoginMissingUsername];
        return;
    }
    else if ([password length] == 0) {
        [self loginFailedWithErrorCode:LoginMissingPassword];
        return;
    }
   
    RTClientCredentials *clientCredentials = [self.dataManager clientCredentialsForUsername:username];

    if (!clientCredentials) {
        [self loginFailedWithErrorCode:LoginUnknownClient];
    }
    else {
        RTUserCredentials *userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                                                password:password];
        __weak typeof(self) welf = self;

        [self.dataManager fetchTokenWithClientCredentials:clientCredentials
                                          userCredentials:userCredentials
                                                 callback:^(RTOAuth2Token *token, NSString *username) {
            [self.dataManager setLoggedInUserWithToken:token username:username callback:^{
                [welf.presenter loginSucceeded];
            }];
        }];
    }
}

- (void)loginDataOperationFailedWithError:(NSError *)error {
    if (![error.domain isEqualToString:RTClientTokenErrorDomain]) {
        [self.presenter loginFailedWithError:error];
        return;
    }
    
    NSInteger errorCode;
    
    if (error.code == InvalidClientCredentials) {
        errorCode = LoginUnknownClient;
    }
    else if (error.code == InvalidUserCredentials) {
        errorCode = LoginInvalidCredentials;
    }
    
    [self loginFailedWithErrorCode:errorCode];
}

- (void)loginFailedWithErrorCode:(RTLoginErrors)code {
    NSError *loginError = [RTErrorFactory loginErrorWithCode:code];
    [self.presenter loginFailedWithError:loginError];
}

@end
