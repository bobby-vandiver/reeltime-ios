#import "RTRecordVideoViewController.h"
#import "RTStoryboardViewControllerFactory.h"

@interface RTRecordVideoViewController ()

@end

@implementation RTRecordVideoViewController

+ (instancetype)viewController {
    NSString *identifier = [RTRecordVideoViewController storyboardIdentifier];
    RTRecordVideoViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];

    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Record Video View Controller";
}

@end
