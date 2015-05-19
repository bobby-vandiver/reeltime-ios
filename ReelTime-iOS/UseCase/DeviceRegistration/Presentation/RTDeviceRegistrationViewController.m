#import "RTDeviceRegistrationViewController.h"
#import "RTDeviceRegistrationPresenter.h"

#import "RTStoryboardViewControllerFactory.h"

@interface RTDeviceRegistrationViewController ()

@property RTDeviceRegistrationPresenter *presenter;

@end

@implementation RTDeviceRegistrationViewController

+ (instancetype)viewControllerWithPresenter:(RTDeviceRegistrationPresenter *)presenter {
    NSString *identifier = [RTDeviceRegistrationViewController storyboardIdentifier];
    RTDeviceRegistrationViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
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
                          forField:(RTDeviceRegistrationViewField)field {
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

- (UIScrollView *)scrollView {
    return self.deviceRegistrationFormScrollView;
}

@end
