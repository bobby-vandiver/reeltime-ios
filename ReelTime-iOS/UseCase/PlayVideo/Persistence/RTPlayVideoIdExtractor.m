#import "RTPlayVideoIdExtractor.h"

@implementation RTPlayVideoIdExtractor

- (NSNumber *)videoIdFromURL:(NSURL *)URL {
    NSArray *pathComponents = URL.pathComponents;
    
    NSInteger apiIdx = [pathComponents indexOfObject:@"api"];
    if (apiIdx == NSNotFound) {
        return nil;
    }
    
    NSInteger playlistIdx = [pathComponents indexOfObject:@"playlists"];
    if (playlistIdx == NSNotFound || apiIdx > playlistIdx) {
        return nil;
    }
    
    NSInteger videoIdIdx = (playlistIdx + 1);
    if (videoIdIdx >= pathComponents.count) {
        return nil;
    }
    
    NSString *videoIdStr = [pathComponents objectAtIndex:videoIdIdx];

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    return [formatter numberFromString:videoIdStr];
}

@end
