#import "RTTestCommon.h"

#import "RTConfirmAccountPresenter.h"
#import "RTConfirmAccountView.h"
#import "RTConfirmAccountInteractor.h"

#import "RTErrorFactory.h"

SpecBegin(RTConfirmAccountPresenter)

describe(@"confirm account presenter", ^{
    
    __block RTConfirmAccountPresenter *presenter;

    __block id<RTConfirmAccountView> view;
    __block RTConfirmAccountInteractor *interactor;

    __block RTErrorPresentationChecker *errorChecker;
    __block RTFieldErrorPresentationChecker *fieldErrorChecker;
    
    ErrorFactoryCallback errorFactoryCallback = ^NSError * (NSInteger code) {
        return [RTErrorFactory confirmAccountErrorWithCode:code];
    };

    beforeEach(^{
        view = mockProtocol(@protocol(RTConfirmAccountView));
        interactor = mock([RTConfirmAccountInteractor class]);
        
        presenter = [[RTConfirmAccountPresenter alloc] initWithView:view interactor:interactor];
    });
    
    describe(@"requesting confirmation email", ^{
        ArrayCallback errorsCallback = ^(NSArray *errors) {
            [presenter confirmationEmailFailedWithErrors:errors];
        };
        
        beforeEach(^{
            errorChecker = [[RTErrorPresentationChecker alloc] initWithView:view
                                                             errorsCallback:errorsCallback
                                                       errorFactoryCallback:errorFactoryCallback];
        });
        
        it(@"should notify interactor to send email", ^{
            [presenter requestedConfirmationEmail];
            [verify(interactor) sendConfirmationEmail];
        });
        
        it(@"email was sent", ^{
            [presenter confirmationEmailSent];
            [verify(view) showMessage:@"Please check your email for the confirmation code"];
        });
        
        it(@"unable to send email", ^{
            [errorChecker verifyErrorMessage:@"Unable to send confirmation email"
                         isShownForErrorCode:RTConfirmAccountErrorEmailFailure];
        });
    });
    
    describe(@"requesting confirmation", ^{
        ArrayCallback errorsCallback = ^(NSArray *errors) {
            [presenter confirmAccountFailedWithErrors:errors];
        };
        
        beforeEach(^{
            errorChecker = [[RTErrorPresentationChecker alloc] initWithView:view
                                                             errorsCallback:errorsCallback
                                                       errorFactoryCallback:errorFactoryCallback];
            
            fieldErrorChecker = [[RTFieldErrorPresentationChecker alloc] initWithView:view
                                                                       errorsCallback:errorsCallback
                                                                 errorFactoryCallback:errorFactoryCallback];
        });
        
        it(@"should pass code to interactor", ^{
            [presenter requestedConfirmationWithCode:confirmationCode];
            [verify(interactor) confirmAccountWithCode:confirmationCode];
        });
        
        it(@"account confirmed", ^{
            [presenter confirmAccountSucceeded];
            [verify(view) showMessage:@"Your account has been confirmed"];
        });
        
        it(@"missing confirmation code", ^{
            [fieldErrorChecker verifyErrorMessage:@"Confirmation code is required"
                              isShownForErrorCode:RTConfirmAccountErrorMissingConfirmationCode
                                            field:RTConfirmAccountViewFieldConfirmationCode];
        });
        
        it(@"invalid confirmation code", ^{
            [errorChecker verifyErrorMessage:@"Confirmation code is invalid"
                         isShownForErrorCode:RTConfirmAccountErrorInvalidConfirmationCode];
        });
    });
});

SpecEnd