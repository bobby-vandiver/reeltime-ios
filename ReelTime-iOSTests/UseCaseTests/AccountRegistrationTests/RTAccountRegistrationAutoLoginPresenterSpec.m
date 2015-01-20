#import "RTTestCommon.h"
#import "RTAccountRegistrationAutoLoginPresenter.h"

#import "RTAccountRegistrationPresenter.h"
#import "RTLoginInteractor.h"

#import "RTErrorFactory.h"
#import "RTLoginErrors.h"

SpecBegin(RTAccountRegistrationAutoLoginPresenter)

describe(@"account registration auto login presenter", ^{
   
    __block RTAccountRegistrationAutoLoginPresenter *autoLoginPresenter;

    __block RTAccountRegistrationPresenter *registrationPresenter;
    __block RTLoginInteractor *loginInteractor;
    
    beforeEach(^{
        registrationPresenter = mock([RTAccountRegistrationPresenter class]);
        loginInteractor = mock([RTLoginInteractor class]);
        
        autoLoginPresenter = [[RTAccountRegistrationAutoLoginPresenter alloc] initWithAccountRegistrationPresenter:registrationPresenter loginInteractor:loginInteractor];
    });
    
    it(@"should notify registration presenter of successful login", ^{
        [autoLoginPresenter loginSucceeded];
        [verify(registrationPresenter) registrationWithAutoLoginSucceeded];
    });
    
    it(@"should notify registration presenter of login failure", ^{
        NSError *loginError = [RTErrorFactory loginErrorWithCode:LoginUnableToSetCurrentlyLoggedInUser];
        [autoLoginPresenter loginFailedWithErrors:@[loginError]];

        MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
        [verify(registrationPresenter) registrationWithAutoLoginFailedWithErrors:[errorCaptor capture]];
        
        NSArray *errors = [errorCaptor value];
        expect([errors count]).to.equal(1);
        expect([errors objectAtIndex:0]).to.equal(loginError);
    });
});

SpecEnd
