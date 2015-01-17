#import "RTStoryboardViewControllerFactory.h"

@implementation RTStoryboardViewControllerFactory

+ (UIStoryboard *)mainStoryboard {
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (RTLoginViewController *)loginViewController {
    NSString *identifier = [RTLoginViewController storyboardIdentifier];
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:identifier];
}

@end
