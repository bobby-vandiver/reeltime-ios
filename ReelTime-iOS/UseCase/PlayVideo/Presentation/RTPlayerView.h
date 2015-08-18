#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

// Based on the example PlayerView class provided in Apple's documentation:
// https://developer.apple.com/library/ios/documentation/AudioVideo/Conceptual/AVFoundationPG/Articles/02_Playback.html

@interface RTPlayerView : UIView

@property (nonatomic) AVPlayer *player;

@property (readonly) AVPlayerLayer *playerLayer;

@end
