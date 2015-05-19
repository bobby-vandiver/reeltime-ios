#import "RTTestCommon.h"

#import "RTResetPasswordViewController.h"
#import "RTResetPasswordPresenter.h"

SpecBegin(RTResetPasswordViewController)

describe(@"reset password view controller", ^{

    __block RTResetPasswordViewController *viewController;
    __block RTResetPasswordPresenter *presenter;
    
    __block UITextField *emailUsernameField;
    __block UITextField *resetUsernameField;

    __block UITextField *passwordField;
    __block UITextField *confirmationPasswordField;
    
    __block UITextField *clientNameField;
    __block UITextField *resetCodeField;
    
    beforeEach(^{
        emailUsernameField = [[UITextField alloc] init];
        resetUsernameField = [[UITextField alloc] init];
        
        passwordField = [[UITextField alloc] init];
        confirmationPasswordField = [[UITextField alloc] init];
        
        clientNameField = [[UITextField alloc] init];
        resetCodeField = [[UITextField alloc] init];
        
        presenter = mock([RTResetPasswordPresenter class]);
        viewController = [RTResetPasswordViewController viewControllerWithPresenter:presenter];
        
        viewController.emailUsernameField = emailUsernameField;
        viewController.resetUsernameField = resetUsernameField;
        
        viewController.passwordField = passwordField;
        viewController.confirmationPasswordField = confirmationPasswordField;
        
        viewController.clientNameField = clientNameField;
        viewController.resetCodeField = resetCodeField;
    });
    
    describe(@"pressing send email button", ^{
        it(@"should request reset password email", ^{
            emailUsernameField.text = username;

            [viewController pressedSendResetEmailButton];
            [verify(presenter) requestedResetPasswordEmailForUsername:username];
        });
    });
    
    describe(@"pressing reset password for registered client button", ^{
        it(@"should request reset", ^{
            resetUsernameField.text = username;
            
            passwordField.text = password;
            confirmationPasswordField.text = @"confirm";
            
            resetCodeField.text = resetCode;
            
            [viewController pressedResetPasswordForRegisteredClientButton];
            [verify(presenter) requestedResetPasswordWithCode:resetCode username:username password:password confirmationPassword:@"confirm"];
        });
    });
    
    describe(@"pressing reset password for new client button", ^{
        it(@"should request reset", ^{
            resetUsernameField.text = username;
            
            passwordField.text = password;
            confirmationPasswordField.text = @"confirm";
            
            clientNameField.text = clientName;
            resetCodeField.text = resetCode;
            
            [viewController pressedResetPasswordForNewClientButton];
            [verify(presenter) requestedResetPasswordWithCode:resetCode username:username password:password confirmationPassword:@"confirm" clientName:clientName];
        });
    });
});

SpecEnd