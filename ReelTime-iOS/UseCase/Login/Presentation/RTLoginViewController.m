#import "RTLoginViewController.h"
#import "RTLoginPresenter.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTLogging.h"

@interface RTLoginViewController ()

@property RTLoginPresenter *presenter;

@end

@implementation RTLoginViewController

+ (instancetype)viewControllerWithPresenter:(RTLoginPresenter *)presenter {
    RTLoginViewController *controller = [RTStoryboardViewControllerFactory storyboardViewController:self];

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

- (IBAction)pressedRegisterDeviceButton {
    [self.presenter requestedDeviceRegistration];
}

- (IBAction)pressedRegisterAccountButton {
    [self.presenter requestedAccountRegistration];
}

- (IBAction)pressedResetPasswordButton {
    [self.presenter requestedResetPassword];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.usernameField.text = @"";
    self.passwordField.text = @"";
}

- (UIScrollView *)scrollView {
    return self.loginFormScrollView;
}

@end
