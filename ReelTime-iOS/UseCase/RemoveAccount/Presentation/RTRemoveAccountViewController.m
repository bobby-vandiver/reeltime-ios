#import "RTRemoveAccountViewController.h"
#import "RTRemoveAccountPresenter.h"

#import "RTStoryboardViewControllerFactory.h"

@interface RTRemoveAccountViewController ()

@property RTRemoveAccountPresenter *presenter;

@end

@implementation RTRemoveAccountViewController

+ (instancetype)viewControllerWithPresenter:(RTRemoveAccountPresenter *)presenter {
    RTRemoveAccountViewController *controller = [RTStoryboardViewControllerFactory storyboardViewController:self];

    if (controller) {
        controller.presenter = presenter;

    }
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Remove Account View Controller";
}

- (void)showErrorMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (IBAction)pressedRemoveButton {
    [self.presenter requestedAccountRemoval];
}

@end
