#import "RTAccountRegistrationAutoLoginPresenter.h"
#import "RTAccountRegistrationPresenter.h"

@interface RTAccountRegistrationAutoLoginPresenter ()

@property RTAccountRegistrationPresenter *registrationPresenter;

@end

@implementation RTAccountRegistrationAutoLoginPresenter

- (instancetype)initWithAccountRegistrationPresenter:(RTAccountRegistrationPresenter *)registrationPresenter
                                     loginInteractor:(RTLoginInteractor *)loginInteractor {
    self = [super init];
    if (self) {
        self.registrationPresenter = registrationPresenter;
    }
    return self;
}

- (void)loginSucceeded {
    [self.registrationPresenter registrationWithAutoLoginSucceeded];
}

- (void)loginFailedWithErrors:(NSArray *)errors {
    [self.registrationPresenter registrationWithAutoLoginFailedWithError:errors];
}

@end
