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
    
    describe(@"when register button is pressed", ^{
        NSString *confirmationPassword = [NSString stringWithFormat:@"%@a", password];

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