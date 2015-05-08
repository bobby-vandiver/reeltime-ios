#import "RTKeyboardAwareFormViewController.h"

#import "RTLoginView.h"
#import "RTStoryboardViewController.h"

@class RTLoginPresenter;

@interface RTLoginViewController : RTKeyboardAwareFormViewController <RTLoginView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIScrollView *loginFormScrollView;

+ (RTLoginViewController *)viewControllerWithPresenter:(RTLoginPresenter *)presenter;

- (IBAction)pressedLoginButton;

- (IBAction)pressedRegisterButton;

@end
