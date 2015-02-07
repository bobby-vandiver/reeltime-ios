#import "RTLoginViewController.h"
#import "RTLoginPresenter.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTLoginPresentationModel.h"

@interface RTLoginViewController ()

@property RTLoginPresenter *presenter;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

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

- (void)updateWithPresentationModel:(RTLoginPresentationModel *)model {
    if (model.unknownErrorOccurred.condition) {
        [self showErrorMessage:model.unknownErrorOccurred.message];
    }
    else if (!model.validCredentials.condition) {
        [self showErrorMessage:model.validCredentials.message];
    }
    else {
        if (!model.validUsername.condition) {
            [self showErrorMessage:model.validUsername.message];
        }
        if (!model.validPassword.condition) {
            [self showErrorMessage:model.validPassword.message];
        }
    }
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
