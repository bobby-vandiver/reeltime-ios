#import "RTLoginInteractor.h"
#import "RTLoginInteractorDelegate.h"

#import "RTLoginDataManager.h"
#import "RTUserCredentials.h"

#import "RTLoginError.h"
#import "RTErrorFactory.h"

@interface RTLoginInteractor ()

@property (weak) id<RTLoginInteractorDelegate> delegate;
@property RTLoginDataManager *dataManager;

@end

@implementation RTLoginInteractor

- (instancetype)initWithDelegate:(id<RTLoginInteractorDelegate>)delegate
                     dataManager:(RTLoginDataManager *)dataManager {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.dataManager = dataManager;
    }
    return self;
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password {
    NSArray *errors;
    BOOL valid = [self validateUsername:username password:password errors:&errors];

    if (!valid) {
        [self.delegate loginFailedWithErrors:errors];
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
                [welf.delegate loginSucceeded];
            }];
        }];
    }
}

- (BOOL)validateUsername:(NSString *)username
                password:(NSString *)password
                  errors:(NSArray *__autoreleasing *)errors {
    BOOL valid = YES;
    NSMutableArray *errorContainer = [NSMutableArray array];
    
    if ([username length] == 0) {
        [errorContainer addObject:[RTErrorFactory loginErrorWithCode:LoginMissingUsername]];
    }
    if ([password length] == 0) {
        [errorContainer addObject:[RTErrorFactory loginErrorWithCode:LoginMissingPassword]];
    }
    
    if ([errorContainer count] > 0) {
        valid = NO;

        if (errors) {
            *errors = errorContainer;
        }
    }
    
    return valid;
}

- (void)loginDataOperationFailedWithError:(NSError *)error {
    [self.delegate loginFailedWithErrors:@[error]];
}

- (void)loginFailedWithErrorCode:(RTLoginError)code {
    NSError *loginError = [RTErrorFactory loginErrorWithCode:code];
    [self.delegate loginFailedWithErrors:@[loginError]];
}

@end
