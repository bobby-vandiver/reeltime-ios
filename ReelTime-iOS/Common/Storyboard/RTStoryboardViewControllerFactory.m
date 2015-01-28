#import "RTStoryboardViewControllerFactory.h"

#import "RTLoginViewController.h"
#import "RTAccountRegistrationViewController.h"

@implementation RTStoryboardViewControllerFactory

+ (id)viewControllerWithStoryboardIdentifier:(NSString *)identifier {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [mainStoryboard instantiateViewControllerWithIdentifier:identifier];
}

@end
