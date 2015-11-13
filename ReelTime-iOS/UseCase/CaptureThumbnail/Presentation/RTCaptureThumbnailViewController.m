#import "RTCaptureThumbnailViewController.h"
#import "RTCaptureThumbnailPresenter.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTPlayerFactory.h"

#import "RTPlayerView.h"
#import "RTPlayVideoNotification.h"

#import "RTLogging.h"

#import <AVFoundation/AVFoundation.h>

#import "AVPlayer+StatusText.h"
#import "AVPlayerItem+StatusText.h"

static NSString *const StatusKeyPath = @"status";

@interface RTCaptureThumbnailViewController ()

@property RTCaptureThumbnailPresenter *presenter;

@property (copy) NSURL *videoURL;
@property RTPlayerFactory *playerFactory;

@property NSNotificationCenter *notificationCenter;

@property (strong, nonatomic) AVPlayer *player;

@end

// TODO: Refactor video playback into its own class and reuse it for thumbnail capture and regular video playback!

@implementation RTCaptureThumbnailViewController

+ (instancetype)viewControllerForVideo:(NSURL *)videoURL
                         withPresenter:(RTCaptureThumbnailPresenter *)presenter
                         playerFactory:(RTPlayerFactory *)playerFactory
                    notificationCenter:(NSNotificationCenter *)notificationCenter {
    
    RTCaptureThumbnailViewController *controller = [RTStoryboardViewControllerFactory storyboardViewController:self];
    
    if (controller) {
        controller.videoURL = videoURL;
        controller.presenter = presenter;
        controller.playerFactory = playerFactory;
        controller.notificationCenter = notificationCenter;
    }

    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Capture Thumbnail View Controller";
}

- (void)viewWillAppear:(BOOL)animated {
    [self setUpPlayer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self pause];
    [self tearDownPlayer];
}

- (void)setUpPlayer {
    self.player = [self.playerFactory playerForVideoURL:self.videoURL];
    
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
    [self.player addObserver:self forKeyPath:StatusKeyPath options:0 context:NULL];
    [self.player.currentItem addObserver:self forKeyPath:StatusKeyPath options:0 context:NULL];
    
    [self.notificationCenter addObserver:self
                                selector:@selector(reachedEndOfVideo:)
                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                  object:self.player.currentItem];
    
    [self.notificationCenter addObserver:self
                                selector:@selector(reloadVideo:)
                                    name:RTPlayVideoNotificationReloadVideo
                                  object:nil];
}

- (void)reachedEndOfVideo:(NSNotification *)notification {
    [self seekToStart];
}

- (void)reloadVideo:(NSNotification *)notification {
    if (self.player.status != AVPlayerStatusReadyToPlay) {
        [self tearDownPlayer];
        [self setUpPlayer];
    }
    
}

- (void)removeObservers {
    [self.notificationCenter removeObserver:self
                                       name:RTPlayVideoNotificationReloadVideo
                                     object:nil];
    
    [self.notificationCenter removeObserver:self
                                       name:AVPlayerItemDidPlayToEndTimeNotification
                                     object:self.player.currentItem];
    
    [self.player.currentItem removeObserver:self forKeyPath:StatusKeyPath];
    
    [self.player removeObserver:self forKeyPath:StatusKeyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (object == self.player && [keyPath isEqual:StatusKeyPath]) {

        if (self.player.status == AVPlayerStatusReadyToPlay) {
            [self play];
        }
        else if (self.player.status == AVPlayerStatusFailed) {
            DDLogError(@"Received AVPlayerStatusFailed with error = %@", self.player.error);
        }
    }
    else if (object == self.player.currentItem && [keyPath isEqual:StatusKeyPath]) {

        if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
            DDLogError(@"Received AVPlayerItemStatusFailed with error = %@", self.player.currentItem.error);
        }
    }
}

- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

- (void)seekToStart {
    [self.player seekToTime:kCMTimeZero];
    [self pause];
}

- (IBAction)pressedCaptureButton {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"small" ofType:@"png"];

    NSURL *placeholderThumbnailURL = [NSURL fileURLWithPath:path];
    [self.presenter capturedThumbnail:placeholderThumbnailURL forVideo:self.videoURL];
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
