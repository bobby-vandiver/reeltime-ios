#import "RTCaptureThumbnailViewController.h"
#import "RTStoryboardViewControllerFactory.h"

@implementation RTCaptureThumbnailViewController

+ (instancetype)viewController {
    return [RTStoryboardViewControllerFactory storyboardViewController:self];
}

+ (NSString *)storyboardIdentifier {
    return @"Capture Thumbnail View Controller";
}

- (IBAction)pressedCaptureButton {
}

@end
