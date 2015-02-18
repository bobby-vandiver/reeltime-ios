#import "RTLoginViewController.h"
#import "RTLoginPresenter.h"

#import "RTStoryboardViewControllerFactory.h"

@interface RTLoginViewController ()

@property RTLoginPresenter *presenter;

@end

@implementation RTLoginViewController

+ (RTLoginViewController *)viewControllerWithPresenter:(RTLoginPresenter *)presenter {
    NSString *identifier = [RTLoginViewController storyboardIdentifier];
    RTLoginViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];

    if (controller) {
        controller.presenter = presenter;
    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Login View Controller";
}

- (IBAction)pressedLoginButton {
    [self.presenter requestedLoginWithUsername:self.usernameField.text
                                      password:self.passwordField.text];
}

- (IBAction)pressedRegisterButton {
    [self.presenter requestedAccountRegistration];
}

- (void)showValidationErrorMessage:(NSString *)message
                          forField:(RTLoginViewField)field {
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

@end
