#import "RTTestCommon.h"

#import "RTChangePasswordViewController.h"
#import "RTChangePasswordPresenter.h"

SpecBegin(RTChangePasswordViewController)

describe(@"change password view controller", ^{
    
    __block RTChangePasswordViewController *viewController;
    __block RTChangePasswordPresenter *presenter;
    
    __block UITextField *passwordField;
    __block UITextField *confirmationPasswordField;

    beforeEach(^{
        presenter = mock([RTChangePasswordPresenter class]);
        viewController = [RTChangePasswordViewController viewControllerWithPresenter:presenter];
        
        passwordField = [[UITextField alloc] init];
        confirmationPasswordField = [[UITextField alloc] init];
        
        viewController.passwordField = passwordField;
        viewController.confirmationPasswordField = confirmationPasswordField;
    });
    
    describe(@"when view will appear", ^{
        it(@"should reset fields", ^{
            passwordField.text = password;
            confirmationPasswordField.text = confirmationPassword;
            
            [viewController viewWillAppear:anything()];
            
            expect(passwordField.text).to.equal(BLANK);
            expect(confirmationPasswordField.text).to.equal(BLANK);
        });
    });
    
    describe(@"when save button is pressed", ^{
        it(@"should request password change for the supplied information", ^{
            viewController.passwordField.text = password;
            viewController.confirmationPasswordField.text = confirmationPassword;
            
            [viewController pressedSaveButton];
            [verify(presenter) requestedPasswordChangeWithPassword:password confirmationPassword:confirmationPassword];
        });
    });
});

SpecEnd