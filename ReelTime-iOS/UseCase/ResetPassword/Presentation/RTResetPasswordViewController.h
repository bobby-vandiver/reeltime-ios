#import "RTKeyboardAwareFormViewController.h"

#import "RTResetPasswordView.h"
#import "RTStoryboardViewController.h"

@class RTResetPasswordPresenter;

@interface RTResetPasswordViewController : RTKeyboardAwareFormViewController <RTResetPasswordView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITextField *emailUsernameField;

@property (weak, nonatomic) IBOutlet UITextField *resetUsernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *clientNameField;
@property (weak, nonatomic) IBOutlet UITextField *resetCodeField;

+ (instancetype)viewControllerWithPresenter:(RTResetPasswordPresenter *)presenter;

- (IBAction)pressedSendResetEmailButton;

- (IBAction)pressedResetPasswordForRegisteredClientButton;

- (IBAction)pressedResetPasswordForNewClientButton;

@end
