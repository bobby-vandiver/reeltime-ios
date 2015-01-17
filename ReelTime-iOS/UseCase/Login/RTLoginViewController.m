#import "RTLoginViewController.h"
#import "RTLoginPresenter.h"

@interface RTLoginViewController ()

@property RTLoginPresenter *presenter;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation RTLoginViewController

+ (NSString *)storyboardIdentifier {
    return @"Login View Controller";
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)pressedLoginButton:(UIButton *)sender {
    [self.presenter requestedLoginWithUsername:self.usernameField.text
                                      password:self.passwordField.text];
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
