#import <UIKit/UIKit.h>

#import "RTLoginView.h"
#import "RTStoryboardViewController.h"

@class RTLoginPresenter;

@interface RTLoginViewController : UIViewController <RTLoginView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

+ (RTLoginViewController *)viewControllerWithPresenter:(RTLoginPresenter *)presenter;

- (IBAction)pressedLoginButton;

- (IBAction)pressedRegisterButton;

@end
