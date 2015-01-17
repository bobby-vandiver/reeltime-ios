#import "RTLoginViewController.h"

@interface RTLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation RTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)pressedLoginButton:(UIButton *)sender {
    NSLog(@"pressed button -- username: %@, password: %@",
          self.usernameField.text, self.passwordField.text);
}

@end
