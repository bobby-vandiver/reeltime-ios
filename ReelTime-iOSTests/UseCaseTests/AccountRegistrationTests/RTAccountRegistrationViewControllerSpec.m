#import "RTTestCommon.h"

#import "RTAccountRegistrationViewController.h"
#import "RTAccountRegistrationPresenter.h"

SpecBegin(RTAccountRegistrationViewController)

describe(@"account registration view controller", ^{

    __block RTAccountRegistrationViewController *viewController;
    __block RTAccountRegistrationPresenter *presenter;
    
    __block UITextField *usernameField;
    __block UITextField *passwordField;
    __block UITextField *confirmationPasswordField;
    __block UITextField *emailField;
    __block UITextField *displayNameField;
    __block UITextField *clientNameField;
    
    beforeEach(^{
        usernameField = [[UITextField alloc] init];
        passwordField = [[UITextField alloc] init];
        confirmationPasswordField = [[UITextField alloc] init];
        emailField = [[UITextField alloc] init];
        displayNameField = [[UITextField alloc] init];
        clientNameField = [[UITextField alloc] init];
        
        presenter = mock([RTAccountRegistrationPresenter class]);
        viewController = [RTAccountRegistrationViewController viewControllerWithPresenter:presenter];
        
        viewController.usernameField = usernameField;
        viewController.passwordField = passwordField;
        viewController.confirmationPasswordField = confirmationPasswordField;
        viewController.emailField = emailField;
        viewController.displayNameField = displayNameField;
        viewController.clientNameField = clientNameField;
    });
    
    describe(@"when view will appear", ^{
        it(@"should reset fields", ^{
            usernameField.text = username;
            passwordField.text = password;
            confirmationPasswordField.text = confirmationPassword;
            emailField.text = email;
            displayNameField.text = displayName;
            clientNameField.text = clientName;
            
            [viewController viewWillAppear:anything()];

            expect(usernameField.text).to.equal(BLANK);
            expect(passwordField.text).to.equal(BLANK);
            expect(confirmationPasswordField.text).to.equal(BLANK);
            expect(emailField.text).to.equal(BLANK);
            expect(displayNameField.text).to.equal(BLANK);
            expect(clientNameField.text).to.equal(BLANK);
        });
    });
    
    describe(@"when register button is pressed", ^{
        it(@"should request account registration", ^{
            usernameField.text = username;
            passwordField.text = password;
            confirmationPasswordField.text = confirmationPassword;
            emailField.text = email;
            displayNameField.text = displayName;
            clientNameField.text = clientName;
            
            [viewController pressedRegisterButton];
            [verify(presenter) requestedAccountRegistrationWithUsername:username
                                                               password:password
                                                   confirmationPassword:confirmationPassword
                                                                  email:email
                                                            displayName:displayName
                                                             clientName:clientName];
        });
    });
});

SpecEnd