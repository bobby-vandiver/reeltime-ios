#import "RTTestCommon.h"

#import "RTChangePasswordPresenter.h"
#import "RTChangePasswordView.h"
#import "RTChangePasswordInteractor.h"

#import "RTErrorFactory.h"

SpecBegin(RTChangePasswordPresenter)

describe(@"change password presenter", ^{
    
    __block RTChangePasswordPresenter *presenter;

    __block id<RTChangePasswordView> view;
    __block RTChangePasswordInteractor *interactor;
    
    beforeEach(^{
        interactor = mock([RTChangePasswordInteractor class]);
        view = mockProtocol(@protocol(RTChangePasswordView));

        presenter = [[RTChangePasswordPresenter alloc] initWithView:view interactor:interactor];
    });
    
    describe(@"requesting password change", ^{
        it(@"should pass on to interactor", ^{
            [presenter requestedPasswordChangeWithPassword:password confirmationPassword:confirmationPassword];
            [verify(interactor) changePassword:password confirmationPassword:confirmationPassword];
        });
    });
    
    describe(@"password change was successful", ^{
        it(@"should present a success message", ^{
            [presenter changePasswordSucceeded];
            [verify(view) showMessage:@"Password change succeeded"];
        });
    });
    
    describe(@"failure messages", ^{
        __block RTErrorPresentationChecker *errorChecker;
        __block RTFieldErrorPresentationChecker *fieldErrorChecker;
        
        ErrorFactoryCallback errorFactoryCallback = ^NSError * (NSInteger code) {
            return [RTErrorFactory changePasswordErrorWithCode:code];
        };
        
        ArrayCallback errorsCallback = ^(NSArray *errors) {
            [presenter changePasswordFailedWithErrors:errors];
        };
        
        beforeEach(^{
            errorChecker = [[RTErrorPresentationChecker alloc] initWithView:view
                                                             errorsCallback:errorsCallback
                                                       errorFactoryCallback:errorFactoryCallback];
            
            fieldErrorChecker = [[RTFieldErrorPresentationChecker alloc] initWithView:view
                                                                       errorsCallback:errorsCallback
                                                                 errorFactoryCallback:errorFactoryCallback];
        });
        
        it(@"missing password", ^{
            [fieldErrorChecker verifyErrorMessage:@"Password is required"
                              isShownForErrorCode:RTChangePasswordErrorMissingPassword
                                            field:RTChangePasswordViewFieldPassword];
        });
        
        it(@"invalid password", ^{
            [fieldErrorChecker verifyErrorMessage:@"Password must be at least 6 characters"
                              isShownForErrorCode:RTChangePasswordErrorInvalidPassword
                                            field:RTChangePasswordViewFieldPassword];
        });
        
        it(@"missing confirmation password", ^{
            [fieldErrorChecker verifyErrorMessage:@"Confirmation password is required"
                              isShownForErrorCode:RTChangePasswordErrorMissingConfirmationPassword
                                            field:RTChangePasswordViewFieldConfirmationPassword];
        });
        
        it(@"password and confirmation password do not match", ^{
            [errorChecker verifyErrorMessage:@"Password and confirmation password must match"
                         isShownForErrorCode:RTChangePasswordErrorConfirmationPasswordDoesNotMatch];
        });
    });
});

SpecEnd
