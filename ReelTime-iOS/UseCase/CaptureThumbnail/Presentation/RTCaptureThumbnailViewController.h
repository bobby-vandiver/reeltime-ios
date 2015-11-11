#import <UIKit/UIKit.h>
#import "RTStoryboardViewController.h"

@class RTCaptureThumbnailPresenter;

@interface RTCaptureThumbnailViewController : UIViewController <RTStoryboardViewController>

+ (instancetype)viewControllerWithPresenter:(RTCaptureThumbnailPresenter *)presenter
                                   forVideo:(NSURL *)videoURL;

- (IBAction)pressedCaptureButton;

@end
