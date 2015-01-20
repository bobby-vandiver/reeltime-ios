#import "RTAccountRegistrationAutoLoginPresenter.h"

#import "RTAccountRegistrationPresenter.h"
#import "RTLoginPresenter.h"

@interface RTAccountRegistrationAutoLoginPresenter ()

@property RTAccountRegistrationPresenter *registrationPresenter;

@end

@implementation RTAccountRegistrationAutoLoginPresenter

- (instancetype)initWithAccountRegistrationPresenter:(RTAccountRegistrationPresenter *)registrationPresenter
                                     loginInteractor:(RTLoginInteractor *)loginInteractor {
    self = [super initWithView:nil
                    interactor:loginInteractor
                     wireframe:nil];
    if (self) {
        self.registrationPresenter = registrationPresenter;
    }
    return self;
}

- (void)requestedLoginWithUsername:(NSString *)username
                          password:(NSString *)password {
    @throw [NSException exceptionWithName:@"RTDirectAutoLoginRequestNotAllowed"
                                   reason:@"Auto login presenter cannot handle direct requests"
                                 userInfo:nil];
}

- (void)loginSucceeded {
    [self.registrationPresenter registrationWithAutoLoginSucceeded];
}

- (void)loginFailedWithError:(NSError *)error {
    [self.registrationPresenter registrationWithAutoLoginFailedWithErrors:@[error]];
}

@end
