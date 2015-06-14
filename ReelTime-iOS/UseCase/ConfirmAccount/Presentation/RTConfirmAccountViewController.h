#import "RTKeyboardAwareFormViewController.h"

#import "RTConfirmAccountView.h"
#import "RTStoryboardViewController.h"

@class RTConfirmAccountPresenter;

@interface RTConfirmAccountViewController : RTKeyboardAwareFormViewController <RTConfirmAccountView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITextField *confirmationCodeField;

+ (instancetype)viewControllerWithPresenter:(RTConfirmAccountPresenter *)presenter;

- (IBAction)pressedSendEmailButton;

- (IBAction)pressedConfirmButton;

@end
