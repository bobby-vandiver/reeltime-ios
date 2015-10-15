#import "RTPlayVideoViewController.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTPlayerFactory.h"

#import "RTPlayerView.h"
#import "RTPlayVideoNotification.h"

#import "RTLogging.h"

#import <AVFoundation/AVFoundation.h>
#import "AVPlayerItem+StatusText.h"

static NSString *const CurrentItemStatusKeyPath = @"currentItem.status";

@interface RTPlayVideoViewController ()

@property (copy) NSNumber *videoId;
@property RTPlayerFactory *playerFactory;

@property NSNotificationCenter *notificationCenter;

@property (strong, nonatomic) AVPlayer *player;
@property id timeObserver;

@end

@implementation RTPlayVideoViewController

+ (instancetype)viewControllerForVideoId:(NSNumber *)videoId
                       withPlayerFactory:(RTPlayerFactory *)playerFactory
                      notificationCenter:(NSNotificationCenter *)notificationCenter {
    
    NSString *identifier = [RTPlayVideoViewController storyboardIdentifier];
    RTPlayVideoViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];
    
    if (controller) {
        controller.videoId = videoId;
        controller.playerFactory = playerFactory;
        controller.notificationCenter = notificationCenter;
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

- (void)viewWillAppear:(BOOL)animated {
    [self addObservers];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self removeObservers];
}

- (void)setUpPlayer {
    self.player = [self.playerFactory playerForVideoId:self.videoId];
    
    self.playerView.player = self.player;
    self.playerView.playerLayer.needsDisplayOnBoundsChange = YES;
}

- (void)addObservers {
    DDLogDebug(@"Adding observers");
    
    [self.player addObserver:self forKeyPath:CurrentItemStatusKeyPath options:0 context:NULL];
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                                                  queue:dispatch_get_main_queue()
                                                             usingBlock:[self timeObserverCallback]];
    
    [self.notificationCenter addObserver:self
                                selector:@selector(reachedEndOfVideo:)
                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                  object:self.player.currentItem];
    
    [self.notificationCenter addObserver:self
                                selector:@selector(reloadVideo:)
                                    name:RTPlayVideoNotificationReloadVideo
                                  object:nil];
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
    DDLogDebug(@"Reached end of video");
    [self seekToStart];
}

- (void)reloadVideo:(NSNotification *)notification {
    DDLogDebug(@"Reloading video with userInfo = %@", notification.userInfo);
    [self setUpPlayer];
}

- (void)removeObservers {
    DDLogDebug(@"Removing observers");

    [self.notificationCenter removeObserver:self
                                       name:RTPlayVideoNotificationReloadVideo
                                     object:nil];
    
    [self.notificationCenter removeObserver:self
                                       name:AVPlayerItemDidPlayToEndTimeNotification
                                     object:self.player.currentItem];
    
    [self.player removeTimeObserver:self.timeObserver];
    [self.player removeObserver:self forKeyPath:CurrentItemStatusKeyPath];
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

- (NSString *)stringForBool:(BOOL)b {
    return b ? @"YES" : @"NO";
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
