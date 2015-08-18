#import "RTPlayVideoViewController.h"
#import "RTStoryboardViewControllerFactory.h"

#import "RTPlayerView.h"
#import "RTLogging.h"

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

    self.playerView.player = self.player;
    self.playerView.playerLayer.needsDisplayOnBoundsChange = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    DDLogDebug(@"Adding observers");
    
    [self.player addObserver:self forKeyPath:@"status" options:0 context:NULL];
    [self.playerView.playerLayer addObserver:self forKeyPath:@"readyForDisplay" options:0 context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated {
    DDLogDebug(@"Removing observers");
    
    [self.player removeObserver:self forKeyPath:@"status"];
    [self.playerView.playerLayer removeObserver:self forKeyPath:@"readyForDisplay"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    BOOL objectIsPlayer = (object == self.player);
    BOOL objectIsPlayerLayer = (object == self.playerView.playerLayer);

    if (objectIsPlayer) {
        BOOL isStatusNotification = [keyPath isEqualToString:@"status"];

        if (isStatusNotification) {
            DDLogDebug(@"Received status = %@", [self playerStatusText]);
        }
    }
    else if (objectIsPlayerLayer) {
        BOOL isReadyForDisplayNotification = [keyPath isEqualToString:@"readyForDisplay"];
        
        if (isReadyForDisplayNotification) {
            DDLogDebug(@"Received readyForDisplay = %@", self.playerView.playerLayer.readyForDisplay ? @"YES" : @"NO");
        }
    }
}

- (NSString *)playerStatusText {
    NSString *status = nil;
    
    switch (self.player.status) {
        case AVPlayerStatusFailed:
            status = @"AVPlayerStatusFailed";
            break;
            
        case AVPlayerStatusReadyToPlay:
            status = @"AVPlayerStatusReadyToPlay";
            break;
            
        default:
            status = @"AVPlayerStatusUnknown";
            break;
    }
    
    return status;
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
