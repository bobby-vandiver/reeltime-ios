#import "RTDeviceRegistrationViewController.h"
#import "RTDeviceRegistrationPresenter.h"

#import "RTStoryboardViewControllerFactory.h"

@interface RTDeviceRegistrationViewController ()

@property RTDeviceRegistrationPresenter *presenter;

@end

@implementation RTDeviceRegistrationViewController

+ (instancetype)viewControllerWithPresenter:(RTDeviceRegistrationPresenter *)presenter {
    RTDeviceRegistrationViewController *controller = [RTStoryboardViewControllerFactory storyboardViewController:self];

    if (controller) {
        controller.presenter = presenter;
    }

    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Device Registration View Controller";
}

- (IBAction)pressedRegisterButton {
    [self.presenter requestedDeviceRegistrationWithClientName:self.clientNameField.text
                                                     username:self.usernameField.text
                                                     password:self.passwordField.text];
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
    self.clientNameField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.usernameField.text = @"";
    self.passwordField.text = @"";
    self.clientNameField.text = @"";
}

- (UIScrollView *)scrollView {
    return self.deviceRegistrationFormScrollView;
}

@end
