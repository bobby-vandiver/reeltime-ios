#import "RTCaptureThumbnailViewController.h"
#import "RTCaptureThumbnailPresenter.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTPlayerFactory.h"

#import "RTPlayerView.h"
#import "RTPlayVideoNotification.h"

#import "RTFilePathGenerator.h"
#import "RTLogging.h"

#import <AVFoundation/AVFoundation.h>

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "AVPlayer+StatusText.h"
#import "AVPlayerItem+StatusText.h"

static NSString *const StatusKeyPath = @"status";

@interface RTCaptureThumbnailViewController ()

@property RTCaptureThumbnailPresenter *presenter;

@property (copy) NSURL *videoURL;
@property RTPlayerFactory *playerFactory;

@property NSNotificationCenter *notificationCenter;
@property RTFilePathGenerator *filePathGenerator;

@property (strong, nonatomic) AVPlayer *player;
@property id timeObserver;

@property CMTime currentTime;

@end

// TODO: Refactor video playback into its own class and reuse it for thumbnail capture and regular video playback!

@implementation RTCaptureThumbnailViewController

+ (instancetype)viewControllerForVideo:(NSURL *)videoURL
                         withPresenter:(RTCaptureThumbnailPresenter *)presenter
                         playerFactory:(RTPlayerFactory *)playerFactory
                    notificationCenter:(NSNotificationCenter *)notificationCenter
                     filePathGenerator:(RTFilePathGenerator *)filePathGenerator {
    
    RTCaptureThumbnailViewController *controller = [RTStoryboardViewControllerFactory storyboardViewController:self];
    
    if (controller) {
        controller.videoURL = videoURL;
        controller.presenter = presenter;
        controller.playerFactory = playerFactory;
        controller.notificationCenter = notificationCenter;
        controller.filePathGenerator = filePathGenerator;
        controller.currentTime = kCMTimeZero;
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
    
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                                                  queue:dispatch_get_main_queue()
                                                             usingBlock:[self timeObserverCallback]];
    
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

- (void (^)(CMTime))timeObserverCallback {
    return ^(CMTime time) {
        self.currentTime = time;
    };
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
    
    [self.player removeTimeObserver:self.timeObserver];
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
    [self.player seekToTime:self.currentTime];
    [self.player play];
}

- (void)pause {
    [self.player pause];
    self.currentTime = self.player.currentItem.currentTime;
}

- (void)seekToStart {
    self.currentTime = kCMTimeZero;

    [self.player seekToTime:self.currentTime];
    [self pause];
}

- (IBAction)pressedCaptureButton {

    NSError *error;
    CGImageRef image = [self generateImageWithError:&error];
    
    if (image) {
        NSString *path = [self.filePathGenerator tempFilePath:@".png"];
        NSURL *thumbnailURL = [NSURL fileURLWithPath:path];
        
        DDLogDebug(@"thumbnailURL = %@", thumbnailURL);

        BOOL success = [self writeThumbnailImage:image toFile:thumbnailURL];
        CGImageRelease(image);
        
        if (success) {
            [self.presenter capturedThumbnail:thumbnailURL forVideo:self.videoURL];
        }
    }
    else {
        DDLogError(@"Failed to create CGImage = %@", error);
    }
}

- (CGImageRef)generateImageWithError:(NSError *__autoreleasing *)error {
    AVAsset *asset = [AVAsset assetWithURL:self.videoURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    return [imageGenerator copyCGImageAtTime:self.currentTime actualTime:NULL error:error];
}

- (BOOL)writeThumbnailImage:(CGImageRef)image
                     toFile:(NSURL *)file {

    CFURLRef URL = (__bridge CFURLRef)file;
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(URL, kUTTypePNG, 1, NULL);

    if (!destination) {
        DDLogError(@"Failed to create CGImageDestination");
        return NO;
    }

    CGImageDestinationAddImage(destination, image, NULL);
    BOOL finalized = CGImageDestinationFinalize(destination);

    CFRelease(destination);
    return finalized;
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
