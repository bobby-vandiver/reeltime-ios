#import "RTConfirmAccountViewController.h"
#import "RTConfirmAccountPresenter.h"

#import "RTStoryboardViewControllerFactory.h"

@interface RTConfirmAccountViewController ()

@property RTConfirmAccountPresenter *presenter;

@end

@implementation RTConfirmAccountViewController

+ (instancetype)viewControllerWithPresenter:(RTConfirmAccountPresenter *)presenter {
    NSString *identifier = [RTConfirmAccountViewController storyboardIdentifier];
    RTConfirmAccountViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.presenter = presenter;
    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Confirm Account View Controller";
}

- (IBAction)pressedSendEmailButton {
    [self.presenter requestedConfirmationEmail];
}

- (IBAction)pressedConfirmButton {
    [self.presenter requestedConfirmationWithCode:self.confirmationCodeField.text];
}

- (void)showMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
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

@end
