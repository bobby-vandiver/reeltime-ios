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
                   error:(NSError **)error {
    if ([username length] == 0) {
        *error = [NSError rt_loginErrorWithCode:MissingUsername];
    }
    else if ([password length] == 0) {
        *error = [NSError rt_loginErrorWithCode:MissingPassword];
    }
    return *error ? NO : YES;
}

- (void)loginSucceeded {
    
}

- (void)loginFailedWithError:(NSError *)error {
    NSString *message = @"An unknown error occurred";
    
    if ([error.domain isEqualToString:RTLoginErrorDomain]) {
        if (error.code == MissingUsername) {
            message = @"Username is required";
        }
        else if (error.code == MissingPassword) {
            message = @"Password is required";
        }
        else if (error.code == InvalidCredentials) {
            message = @"Invalid username or password";
        }
    }
    
    [self.view showErrorMessage:message];
}

@end
