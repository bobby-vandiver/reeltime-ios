#import "RTStoryboardViewControllerFactory.h"
#import "RTStoryboardViewController.h"

#import <UIKit/UIKit.h>

@implementation RTStoryboardViewControllerFactory

+ (id)storyboardViewController:(Class<RTStoryboardViewController>)clazz {
    NSString *identifier = [clazz storyboardIdentifier];

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [mainStoryboard instantiateViewControllerWithIdentifier:identifier];
}

@end
