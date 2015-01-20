#import "RTLoginInteractorDelegate.h"

@class RTAccountRegistrationPresenter;
@class RTLoginInteractor;

@interface RTAccountRegistrationAutoLoginPresenter : NSObject <RTLoginInteractorDelegate>

- (instancetype)initWithAccountRegistrationPresenter:(RTAccountRegistrationPresenter *)registrationPresenter
                                     loginInteractor:(RTLoginInteractor *)loginInteractor;

@end
