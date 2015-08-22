#import "RTPlayVideoViewController.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTPlayerFactory.h"

#import "RTPlayerView.h"
#import "RTLogging.h"

#import <AVFoundation/AVFoundation.h>
#import "AVPlayerItem+StatusText.h"

@interface RTPlayVideoViewController ()

@property (copy) NSNumber *videoId;
@property RTPlayerFactory *playerFactory;

@property (strong, nonatomic) AVPlayer *player;
@property id timeObserver;

@end

@implementation RTPlayVideoViewController

+ (instancetype)viewControllerWithPlayerFactory:(RTPlayerFactory *)playerFactory
                                     forVideoId:(NSNumber *)videoId {
    
    NSString *identifier = [RTPlayVideoViewController storyboardIdentifier];
    RTPlayVideoViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.playerFactory = playerFactory;
        controller.videoId = videoId;
    }
    
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Play Video View Controller";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.player = [self.playerFactory playerForVideoId:self.videoId];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    self.playerView.player = self.player;
    self.playerView.playerLayer.needsDisplayOnBoundsChange = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    DDLogDebug(@"Adding observers");
    
    [self.player addObserver:self forKeyPath:@"currentItem.status" options:0 context:NULL];
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
    [self.player removeObserver:self forKeyPath:@"currentItem.status"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (object == self.player) {
        DDLogDebug(@"Received status = %@", self.player.currentItem.statusText);
        
        if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            [self setLabel:self.currentTimeLabel toTime:kCMTimeZero];
            [self setLabel:self.totalTimeLabel toTime:self.player.currentItem.duration];
        }
        
    }
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
