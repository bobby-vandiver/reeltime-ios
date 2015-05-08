#import "RTKeyboardAwareFormViewController.h"

#import "RTAccountRegistrationView.h"
#import "RTStoryboardViewController.h"

@class RTAccountRegistrationPresenter;

@interface RTAccountRegistrationViewController : RTKeyboardAwareFormViewController <RTAccountRegistrationView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmationPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *displayNameField;
@property (weak, nonatomic) IBOutlet UITextField *clientNameField;
@property (weak, nonatomic) IBOutlet UIScrollView *accountRegistrationFormScrollView;

+ (RTAccountRegistrationViewController *)viewControllerWithPresenter:(RTAccountRegistrationPresenter *)presenter;

- (IBAction)pressedRegisterButton;

@end
