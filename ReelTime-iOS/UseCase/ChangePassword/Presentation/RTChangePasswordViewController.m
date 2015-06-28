#import "RTChangePasswordViewController.h"
#import "RTChangePasswordPresenter.h"

#import "RTStoryboardViewControllerFactory.h"

@interface RTChangePasswordViewController ()

@property RTChangePasswordPresenter *presenter;

@end

@implementation RTChangePasswordViewController

+ (instancetype)viewControllerWithPresenter:(RTChangePasswordPresenter *)presenter {
    NSString *identifier = [RTChangePasswordViewController storyboardIdentifier];
    RTChangePasswordViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.presenter = presenter;
    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Change Password View Controller";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.passwordField.delegate = self;
    self.confirmationPasswordField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.passwordField.text = @"";
    self.confirmationPasswordField.text = @"";
}

- (UIScrollView *)scrollView {
    return self.changePasswordFormScrollView;
}

- (IBAction)pressedSaveButton {
    [self.presenter requestedPasswordChangeWithPassword:self.passwordField.text
                                   confirmationPassword:self.confirmationPasswordField.text];
}

- (void)showMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)showValidationErrorMessage:(NSString *)message forField:(NSInteger)field {
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
