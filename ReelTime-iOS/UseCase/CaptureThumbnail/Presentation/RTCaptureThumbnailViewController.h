#import <UIKit/UIKit.h>
#import "RTStoryboardViewController.h"

@interface RTCaptureThumbnailViewController : UIViewController <RTStoryboardViewController>

+ (instancetype)viewController;

- (IBAction)pressedCaptureButton;

@end
