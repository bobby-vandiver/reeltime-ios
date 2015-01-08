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
    RTClientCredentials *clientCredentials = [self.dataManager clientCredentialsForUsername:username];

    if (!clientCredentials) {
        [self loginFailedWithErrorCode:UnknownClient];
    }
    else {
        RTUserCredentials *userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                                                password:password];

        id callback = ^(RTOAuth2Token *token, NSString *username) {
            [self.dataManager setLoggedInUserWithToken:token username:username];
        };
        
        [self.dataManager fetchTokenWithClientCredentials:clientCredentials
                                          userCredentials:userCredentials
                                                 callback:callback];
    }
}

- (void)didSetLoggedInUser {
    [self.presenter loginSucceeded];
}

- (void)loginDataOperationFailedWithError:(NSError *)error {
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
}

- (void)loginFailedWithErrorCode:(RTLoginErrors)code {
    NSError *loginError = [RTErrorFactory loginErrorWithCode:code];
    [self.presenter loginFailedWithError:loginError];
}

@end
