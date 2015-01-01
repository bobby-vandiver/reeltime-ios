#import "RTLoginPresenter.h"
#import "RTLoginInteractor.h"
#import "NSError+RTErrorFactory.h"

@interface RTLoginPresenter ()

@property id<RTLoginView> view;
@property RTLoginInteractor *interactor;

@end

@implementation RTLoginPresenter

- (instancetype)initWithView:(id<RTLoginView>)view
                  interactor:(RTLoginInteractor *)interactor {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
    }
    return self;
}

- (void)requestedLoginWithUsername:(NSString *)username
                           password:(NSString *)password {
    NSError *error;
    BOOL credentialsAreValid = [self validUsername:username
                                             password:password
                                                error:&error];
    if (!credentialsAreValid) {
        [self loginFailedWithError:error];
    }
    else {
        [self.interactor loginWithUsername:username password:password];
    }
}

- (BOOL)validUsername:(NSString *)username
                password:(NSString *)password
                   error:(NSError **)outError {
    if ([username length] == 0) {
        *outError = [NSError rt_loginErrorWithCode:MissingUsername];
    }
    else if ([password length] == 0) {
        *outError = [NSError rt_loginErrorWithCode:MissingPassword];
    }
    return *outError ? NO : YES;
}

- (void)loginSucceeded {
    
}

- (void)loginFailedWithError:(NSError *)error {
    NSString *message = @"An unknown error occurred";
    
    if ([error.domain isEqualToString:RTLoginErrorsDomain]) {
        switch (error.code) {
            case MissingUsername:
                message = @"Username is required";
                break;
                
            case MissingPassword:
                message = @"Password is required";
                break;
                
            case InvalidCredentials:
                message = @"Invalid username or password";
                break;
                
            default:
                break;
        }
    }
    
    [self.view showErrorMessage:message];
}

@end
