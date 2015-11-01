#import "RTChangeDisplayNameViewController.h"
#import "RTChangeDisplayNamePresenter.h"

#import "RTStoryboardViewControllerFactory.h"

@interface RTChangeDisplayNameViewController ()

@property RTChangeDisplayNamePresenter *presenter;

@end

@implementation RTChangeDisplayNameViewController

+ (instancetype)viewControllerWithPresenter:(RTChangeDisplayNamePresenter *)presenter {
    RTChangeDisplayNameViewController *controller = [RTStoryboardViewControllerFactory storyboardViewController:self];
    if (controller) {
        controller.presenter = presenter;
    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Change Display Name View Controller";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.displayNameField.text = @"";
}

- (IBAction)pressedSaveButton {
    [self.presenter requestedDisplayNameChangeWithDisplayName:self.displayNameField.text];
}

- (void)showMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)showValidationErrorMessage:(NSString *)message forField:(NSInteger)field {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
