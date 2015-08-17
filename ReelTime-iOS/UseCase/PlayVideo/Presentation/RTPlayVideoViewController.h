#import <UIKit/UIKit.h>

#import "RTStoryboardViewController.h"

@interface RTPlayVideoViewController : UIViewController <RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UIView *videoView;

+ (instancetype)viewControllerForVideoId:(NSNumber *)videoId;

- (IBAction)pressedPlayButton;

- (IBAction)pressedPauseButton;

- (IBAction)pressedResetButton;

@end
