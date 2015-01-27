#import "RTStoryboardViewControllerFactory.h"

#import "RTLoginViewController.h"
#import "RTAccountRegistrationViewController.h"

@implementation RTStoryboardViewControllerFactory

+ (UIStoryboard *)mainStoryboard {
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (RTLoginViewController *)loginViewController {
    NSString *identifier = [RTLoginViewController storyboardIdentifier];
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:identifier];
}

+ (RTAccountRegistrationViewController *)accountRegistrationViewController {
    NSString *identifier = [RTAccountRegistrationViewController storyboardIdentifier];
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:identifier];
}

@end
