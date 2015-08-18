#import "RTPlayVideoViewController.h"
#import "RTStoryboardViewControllerFactory.h"

#import "RTPlayerView.h"
#import "RTLogging.h"

#import <AVFoundation/AVFoundation.h>

@interface RTPlayVideoViewController ()

@property (copy) NSNumber *videoId;
@property (strong, nonatomic) AVPlayer *player;

@property id timeObserver;

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

    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                                                  queue:dispatch_get_main_queue()
                                                             usingBlock:[self timeObserverCallback]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachedEndOfVideo:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];
}

- (void (^)(CMTime))timeObserverCallback {
    __weak RTPlayVideoViewController *weakSelf = self;

    return ^(CMTime time) {
        CMTime duration = weakSelf.player.currentItem.duration;
        
        if (CMTimeCompare(time, duration) >= 0) {
            [weakSelf setLabel:weakSelf.currentTimeLabel toTime:duration];
        }
        else {
            [weakSelf setLabel:weakSelf.currentTimeLabel toTime:time];
        }
    };
}

- (void)reachedEndOfVideo:(NSNotification *)notification {
    [self seekToStart];
}

- (void)viewDidDisappear:(BOOL)animated {
    DDLogDebug(@"Removing observers");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:self.player.currentItem];
    
    [self.player removeTimeObserver:self.timeObserver];
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

            [self setLabel:self.currentTimeLabel toTime:kCMTimeZero];
            [self setLabel:self.totalTimeLabel toTime:self.player.currentItem.duration];
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

- (void)setLabel:(UILabel *)label toTime:(CMTime)time {
    label.text = [NSString stringWithFormat:@"%f", CMTimeGetSeconds(time)];
}

- (void)seekToStart {
    [self.player seekToTime:kCMTimeZero];
    [self.player pause];
}

- (IBAction)pressedPlayButton {
    [self.player play];
}

- (IBAction)pressedPauseButton {
    [self.player pause];
}

- (IBAction)pressedResetButton {
    [self seekToStart];
}

@end
