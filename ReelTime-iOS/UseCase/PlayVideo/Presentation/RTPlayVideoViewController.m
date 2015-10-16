#import "RTPlayVideoViewController.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTPlayerFactory.h"

#import "RTPlayerView.h"
#import "RTPlayVideoNotification.h"

#import "RTOAuth2TokenRenegotiationNotification.h"
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

@property CMTime currentTime;

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
        controller.currentTime = kCMTimeZero;
    }
    
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Play Video View Controller";
}

- (void)viewWillAppear:(BOOL)animated {
    [self setUpPlayer];
//    [self addObservers];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self pause];
    [self tearDownPlayer];
//    [self removeObservers];
}

- (void)setUpPlayer {
    DDLogDebug(@"Setting up player");
    
    self.player = [self.playerFactory playerForVideoId:self.videoId];
    
    self.playerView.player = self.player;
    self.playerView.playerLayer.needsDisplayOnBoundsChange = YES;

    [self addObservers];
}

- (void)tearDownPlayer {
    [self removeObservers];
    
    self.player = nil;
    self.playerView.player = nil;
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
    
    DDLogDebug(@"Leaving addObservers");
}

- (void (^)(CMTime))timeObserverCallback {
    __weak RTPlayVideoViewController *weakSelf = self;

    return ^(CMTime time) {
        self.currentTime = time;

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
    
    switch (self.player.currentItem.status) {
        case AVPlayerItemStatusUnknown:
            DDLogDebug(@"status = AVPlayerItemStatusUnknown");
            break;
            
        case AVPlayerItemStatusReadyToPlay:
            DDLogDebug(@"status = AVPlayerItemStatusReadyToPlay");
            break;
            
        case AVPlayerItemStatusFailed:
            DDLogDebug(@"status = AVPlayerItemStatusFailed");
            
        default:
            break;
    }
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
    
    DDLogDebug(@"Leaving removeObservers");
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

            [self play];
        }
    }
}

- (NSString *)stringForBool:(BOOL)b {
    return b ? @"YES" : @"NO";
}

- (void)setLabel:(UILabel *)label toTime:(CMTime)time {
    label.text = [NSString stringWithFormat:@"%f", CMTimeGetSeconds(time)];
}

- (void)play {
    DDLogDebug(@"Playing at time = %f", CMTimeGetSeconds(self.currentTime));
    
    [self.player seekToTime:self.currentTime];
    [self.player play];
}

- (void)pause {
    [self.player pause];
    self.currentTime = self.player.currentItem.currentTime;

    DDLogDebug(@"Paused at time = %f", CMTimeGetSeconds(self.currentTime));
}

- (void)seekToStart {
    self.currentTime = kCMTimeZero;

    [self.player seekToTime:self.currentTime];
    [self pause];
}

- (IBAction)pressedPlayButton {
    [self play];
}

- (IBAction)pressedPauseButton {
    [self pause];
}

- (IBAction)pressedResetButton {
    [self seekToStart];
}

@end
