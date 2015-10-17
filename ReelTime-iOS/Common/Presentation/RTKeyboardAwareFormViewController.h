#import <UIKit/UIKit.h>

// This implements the Keyboard management strategy demonsrated in Apple's documentation:
// https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html

@interface RTKeyboardAwareFormViewController : UIViewController <UITextFieldDelegate>

@property (readonly) UIScrollView *scrollView;

@end
