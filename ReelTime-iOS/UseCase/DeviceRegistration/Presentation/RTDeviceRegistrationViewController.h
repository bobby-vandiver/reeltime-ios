#import "RTKeyboardAwareFormViewController.h"

#import "RTDeviceRegistrationView.h"
#import "RTStoryboardViewController.h"

@class RTDeviceRegistrationPresenter;

@interface RTDeviceRegistrationViewController : RTKeyboardAwareFormViewController <RTDeviceRegistrationView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *clientNameField;
@property (weak, nonatomic) IBOutlet UIScrollView *deviceRegistrationFormScrollView;

+ (RTDeviceRegistrationViewController *)viewControllerWithPresenter:(RTDeviceRegistrationPresenter *)presenter;

- (IBAction)pressedRegisterButton;

@end
