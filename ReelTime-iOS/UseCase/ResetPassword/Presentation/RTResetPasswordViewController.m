#import "RTResetPasswordViewController.h"
#import "RTResetPasswordPresenter.h"

#import "RTStoryboardViewControllerFactory.h"

@interface RTResetPasswordViewController ()

@property RTResetPasswordPresenter *presenter;

@end

@implementation RTResetPasswordViewController

+ (instancetype)viewControllerWithPresenter:(RTResetPasswordPresenter *)presenter {
    NSString *identifier = [self storyboardIdentifier];
    RTResetPasswordViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    if (controller) {
        controller.presenter = presenter;
    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Reset Password View Controller";
}

- (IBAction)pressedSendResetEmailButton {
    [self.presenter requestedResetPasswordEmailForUsername:self.emailUsernameField.text];
}

- (IBAction)pressedResetPasswordForRegisteredClientButton {
    [self.presenter requestedResetPasswordWithCode:self.resetCodeField.text
                                          username:self.resetUsernameField.text
                                          password:self.passwordField.text
                              confirmationPassword:self.confirmationPasswordField.text];
}

- (IBAction)pressedResetPasswordForNewClientButton {
    [self.presenter requestedResetPasswordWithCode:self.resetCodeField.text
                                          username:self.resetUsernameField.text
                                          password:self.passwordField.text
                              confirmationPassword:self.confirmationPasswordField.text
                                        clientName:self.clientNameField.text];
}

- (void)showValidationErrorMessage:(NSString *)message
                          forField:(NSInteger)field {
    [self showErrorMessage:message];
}

- (void)showErrorMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)showMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UITextField *textField in [self fields]) {
        textField.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    for (UITextField *textField in [self fields]) {
        textField.text = @"";
    }
}

- (NSArray *)fields {
    return @[
             self.emailUsernameField,
             self.resetUsernameField,
             self.passwordField,
             self.confirmationPasswordField,
             self.resetCodeField,
             self.clientNameField
             ];
}

@end
