#import "AVPlayerItem+StatusText.h"

@implementation AVPlayerItem (StatusText)

- (NSString *)statusText {
    NSString *text = nil;
    
    switch (self.status) {
        case AVPlayerItemStatusFailed:
            text = @"AVPlayerItemStatusFailed";
            break;
            
        case AVPlayerItemStatusReadyToPlay:
            text = @"AVPlayerItemStatusReadyToPlay";
            break;
            
        case AVPlayerItemStatusUnknown:
            text = @"AVPlayerItemStatusUnknown";
            break;
            
        default:
            text = @"AVPlayerItemStatusUndefined";
            break;
    }
    
    return text;
}

@end
