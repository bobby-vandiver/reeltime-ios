#import "RTAccountRegistrationViewController.h"
#import "RTAccountRegistrationPresenter.h"

#import "RTStoryboardViewControllerFactory.h"

@interface RTAccountRegistrationViewController ()

@property RTAccountRegistrationPresenter *presenter;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmationPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *clientField;

@end

@implementation RTAccountRegistrationViewController

+ (RTAccountRegistrationViewController *)viewControllerWithPresenter:(RTAccountRegistrationPresenter *)presenter {
    NSString *identifier = [RTAccountRegistrationViewController storyboardIdentifier];
    RTAccountRegistrationViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.presenter = presenter;
    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Account Registration View Controller";
}

- (IBAction)pressedRegisterButton {
    NSLog(@"hello");
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
