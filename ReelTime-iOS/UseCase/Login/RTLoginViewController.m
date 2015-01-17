#import "RTLoginViewController.h"
#import "RTLoginPresenter.h"

@interface RTLoginViewController ()

@property RTLoginPresenter *presenter;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation RTLoginViewController

- (instancetype)initWithPresenter:(RTLoginPresenter *)presenter {
    self = [super init];
    if (self) {
        self.presenter = presenter;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)pressedLoginButton:(UIButton *)sender {
    NSString *message = [NSString stringWithFormat:@"pressed button -- username: %@, password: %@",
                         self.usernameField.text, self.passwordField.text];
    
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
