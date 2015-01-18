#import "RTLoginPresenter.h"

@class RTAccountRegistrationPresenter;
@class RTLoginInteractor;

@interface RTAccountRegistrationAutoLoginPresenter : RTLoginPresenter

- (instancetype)initWithAccountRegistrationPresenter:(RTAccountRegistrationPresenter *)registrationPresenter
                                     loginInteractor:(RTLoginInteractor *)loginInteractor;

@end
