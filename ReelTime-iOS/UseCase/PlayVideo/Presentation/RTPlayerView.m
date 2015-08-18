#import "RTPlayerView.h"

@implementation RTPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return self.playerLayer.player;
}
- (void)setPlayer:(AVPlayer *)player {
    self.playerLayer.player = player;
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)[self layer];
}

@end
