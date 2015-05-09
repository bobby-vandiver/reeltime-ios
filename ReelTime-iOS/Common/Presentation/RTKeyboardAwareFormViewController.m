#import "RTKeyboardAwareFormViewController.h"
#import "RTException.h"

#import "RTLogging.h"

@interface RTKeyboardAwareFormViewController ()

@property (weak) UITextField *activeTextField;

@end

@implementation RTKeyboardAwareFormViewController

- (UIScrollView *)scrollView {
    [NSException raise:RTAbstractMethodException
                format:@"Scroll view must be provided by subclass"];
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterForKeyboardNotifications];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameDidChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
}

- (void)keyboardFrameDidChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];

    CGRect keyboardBeginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGRect frame = self.view.frame;
    CGRect convertedKeyboardBeginFrame = [self.view convertRect:keyboardBeginFrame toView:nil];
    CGRect convertedKeyboardEndFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    
    CGFloat yOffset = frame.origin.y - (convertedKeyboardBeginFrame.origin.y - convertedKeyboardEndFrame.origin.y);
    
    CGFloat top = self.scrollView.contentInset.top + yOffset;
    CGFloat bottom = self.scrollView.contentInset.bottom + yOffset;
    
    CGFloat left = self.scrollView.contentInset.left;
    CGFloat right = self.scrollView.contentInset.right;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(top, left, bottom, right);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // TODO: Scroll active text field into view if keyboard pushes it off screen
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
}
@end
