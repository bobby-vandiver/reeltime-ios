#import "RTKeyboardAwareFormViewController.h"

#import "RTChangeDisplayNameView.h"
#import "RTStoryboardViewController.h"

@class RTChangeDisplayNamePresenter;

@interface RTChangeDisplayNameViewController : RTKeyboardAwareFormViewController <RTChangeDisplayNameView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITextField *displayNameField;
@property (weak, nonatomic) IBOutlet UIScrollView *changeDisplayNameFormScrollView;

+ (instancetype)viewControllerWithPresenter:(RTChangeDisplayNamePresenter *)presenter;

- (IBAction)pressedSaveButton;

@end
