#import <Foundation/Foundation.h>

@interface RTPlaylistURLVideoIdExtractor : NSObject

- (BOOL)supportsURL:(NSURL *)URL;

- (NSNumber *)videoIdFromURL:(NSURL *)URL;

@end
