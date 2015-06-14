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
    });
    
    describe(@"requesting confirmation", ^{
        ArrayCallback errorsCallback = ^(NSArray *errors) {
            [presenter confirmAccountFailedWithErrors:errors];
        };
        
        beforeEach(^{
            errorChecker = [[RTErrorPresentationChecker alloc] initWithView:view
                                                             errorsCallback:errorsCallback
                                                       errorFactoryCallback:errorFactoryCallback];
        });
        
        it(@"should pass code to interactor", ^{
            [presenter requestedConfirmationWithCode:confirmationCode];
            [verify(interactor) confirmAccountWithCode:confirmationCode];
        });
    });
});

SpecEnd