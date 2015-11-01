#import "RTConfirmAccountViewController.h"
#import "RTConfirmAccountPresenter.h"

#import "RTStoryboardViewControllerFactory.h"

@interface RTConfirmAccountViewController ()

@property RTConfirmAccountPresenter *presenter;

@end

@implementation RTConfirmAccountViewController

+ (instancetype)viewControllerWithPresenter:(RTConfirmAccountPresenter *)presenter {
    RTConfirmAccountViewController *controller = [RTStoryboardViewControllerFactory storyboardViewController:self];

    if (controller) {
        controller.presenter = presenter;
    }
    
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Confirm Account View Controller";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.confirmationCodeField.text = @"";
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
