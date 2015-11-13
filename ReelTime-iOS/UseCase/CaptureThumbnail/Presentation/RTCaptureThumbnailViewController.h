#import <UIKit/UIKit.h>
#import "RTStoryboardViewController.h"

@class RTPlayerFactory;
@class RTPlayerView;
@class RTCaptureThumbnailPresenter;

@interface RTCaptureThumbnailViewController : UIViewController <RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet RTPlayerView *playerView;

+ (instancetype)viewControllerForVideo:(NSURL *)videoURL
                         withPresenter:(RTCaptureThumbnailPresenter *)presenter
                         playerFactory:(RTPlayerFactory *)playerFactory
                    notificationCenter:(NSNotificationCenter *)notificationCenter;

- (IBAction)pressedCaptureButton;

- (IBAction)pressedPlayButton;

- (IBAction)pressedPauseButton;

- (IBAction)pressedResetButton;

@end
