#import "AVPlayer+StatusText.h"

@implementation AVPlayer (StatusText)

- (NSString *)statusText {
    NSString *text = nil;
    
    switch (self.status) {
        case AVPlayerStatusUnknown:
            text = @"AVPlayerStatusUnknown";
            break;
            
        case AVPlayerStatusReadyToPlay:
            text = @"AVPlayerStatusReadyToPlay";
            break;
            
        case AVPlayerStatusFailed:
            text = @"AVPlayerStatusFailed";
            break;
            
        default:
            text = @"AVPlayerStatusUndefined";
            break;
    }
    
    return text;
}

@end
