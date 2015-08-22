#import "RTPlaylistURLVideoIdExtractor.h"

@implementation RTPlaylistURLVideoIdExtractor

- (BOOL)supportsURL:(NSURL *)URL {
    return [URL.path containsString:@"/api/playlists/"];
}

- (NSNumber *)videoIdFromURL:(NSURL *)URL {
    return nil;
}

@end
