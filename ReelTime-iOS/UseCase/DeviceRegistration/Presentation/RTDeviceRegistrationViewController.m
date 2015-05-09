#import "RTDeviceRegistrationViewController.h"

@implementation RTDeviceRegistrationViewController

+ (RTDeviceRegistrationViewController *)viewControllerWithPresenter:(RTDeviceRegistrationPresenter *)presenter {
    return nil;
}

+ (NSString *)storyboardIdentifier {
    return nil;
}

- (IBAction)pressedRegisterButton {
}

- (void)showValidationErrorMessage:(NSString *)message
                          forField:(RTDeviceRegistrationViewField)field {
    
}

- (void)showErrorMessage:(NSString *)message {
    
}

@end
