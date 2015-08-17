#import "RTPlayVideoViewController.h"
#import "RTStoryboardViewControllerFactory.h"

#import <AVFoundation/AVFoundation.h>

@interface RTPlayVideoViewController ()

@property (copy) NSNumber *videoId;
@property (strong, nonatomic) AVPlayer *player;

@end

@implementation RTPlayVideoViewController

+ (instancetype)viewControllerForVideoId:(NSNumber *)videoId {
    NSString *identifier = [RTPlayVideoViewController storyboardIdentifier];
    RTPlayVideoViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.videoId = videoId;
    }
    
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Play Video View Controller";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPlayer];
}

- (void)setUpPlayer {
    NSString *formatted = [NSString stringWithFormat:@"http://localhost:8080/reeltime/api/playlists/%@", self.videoId];
    NSURL *url = [NSURL URLWithString:formatted];
    
    self.player = [AVPlayer playerWithURL:url];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame = self.videoView.bounds;
    
    [self.videoView.layer addSublayer:layer];
}

- (IBAction)pressedPlayButton {
    [self.player play];
}

- (IBAction)pressedPauseButton {
    [self.player pause];
}

- (IBAction)pressedResetButton {
    [self.player seekToTime:kCMTimeZero];
}

@end
