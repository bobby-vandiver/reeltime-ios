#import "RTPlayerFactory.h"

#import "RTRestAPI.h"
#import "RTEndpointPathFormatter.h"

@interface RTPlayerFactory ()

@property (copy) NSURL *serverUrl;
@property RTEndpointPathFormatter *pathFormatter;

@end

@implementation RTPlayerFactory

- (instancetype)initWithServerUrl:(NSURL *)serverUrl
                    pathFormatter:(RTEndpointPathFormatter *)pathFormatter {
    self = [super init];
    if (self) {
        self.serverUrl = serverUrl;
        self.pathFormatter = pathFormatter;
    }
    return self;
}

- (AVPlayer *)playerForVideoId:(NSNumber *)videoId {
    NSString *path = [self.pathFormatter formatPath:API_VARIANT_PLAYLIST
                                        withVideoId:[videoId integerValue]];
    
    NSURL *videoUrl = [NSURL URLWithString:path
                             relativeToURL:self.serverUrl];
    
    AVPlayer *player = [AVPlayer playerWithURL:videoUrl];

    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    return player;
}

@end
