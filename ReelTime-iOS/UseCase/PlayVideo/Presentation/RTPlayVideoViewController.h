#import <UIKit/UIKit.h>

@class RTPlayerView;

#import "RTStoryboardViewController.h"

@interface RTPlayVideoViewController : UIViewController <RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet RTPlayerView *playerView;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

+ (instancetype)viewControllerForVideoId:(NSNumber *)videoId;

- (IBAction)pressedPlayButton;

- (IBAction)pressedPauseButton;

- (IBAction)pressedResetButton;

@end
