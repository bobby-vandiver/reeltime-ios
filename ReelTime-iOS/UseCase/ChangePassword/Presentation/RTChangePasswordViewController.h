#import "RTKeyboardAwareFormViewController.h"

#import "RTChangePasswordView.h"
#import "RTStoryboardViewController.h"

@class RTChangePasswordPresenter;

@interface RTChangePasswordViewController : RTKeyboardAwareFormViewController <RTChangePasswordView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmationPasswordField;
@property (weak, nonatomic) IBOutlet UIScrollView *changePasswordFormScrollView;

+ (instancetype)viewControllerWithPresenter:(RTChangePasswordPresenter *)presenter;

- (IBAction)pressedSaveButton;

@end
