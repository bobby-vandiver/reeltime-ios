#import "RTResetPasswordViewController.h"

@implementation RTResetPasswordViewController

+ (instancetype)viewControllerWithPresenter:(RTResetPasswordPresenter *)presenter {
    return nil;
}

+ (NSString *)storyboardIdentifier {
    return @"Reset Password View Controller";
}

- (void)showValidationErrorMessage:(NSString *)message
                          forField:(RTResetPasswordViewField)field {
    
}

- (void)showErrorMessage:(NSString *)message {
    
}

- (void)showMessage:(NSString *)message {
    
}

- (IBAction)pressedSendResetEmailButton {
}

- (IBAction)pressedResetPasswordForRegisteredClientButton {
}

- (IBAction)pressedResetPasswordForNewClientButton {
}
@end
