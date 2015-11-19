#import "RTPlayerFactory.h"

#import "RTRestAPI.h"
#import "RTEndpointPathFormatter.h"

#import "RTCurrentUserService.h"
#import "RTAuthorizationHeaderSupport.h"

#import "RTOAuth2Token.h"
#import "RTLogging.h"

#import "AVURLAsset+HTTPHeaderFieldsKey.h"

@interface RTPlayerFactory ()

@property (copy) NSURL *serverUrl;
@property RTEndpointPathFormatter *pathFormatter;

@property RTAuthorizationHeaderSupport *authorizationHeaderSupport;
@property RTCurrentUserService *currentUserService;

@end

@implementation RTPlayerFactory

- (instancetype)initWithServerUrl:(NSURL *)serverUrl
                    pathFormatter:(RTEndpointPathFormatter *)pathFormatter
       authorizationHeaderSupport:(RTAuthorizationHeaderSupport *)authorizationHeaderSupport
               currentUserService:(RTCurrentUserService *)currentUserService {
    
    self = [super init];
    if (self) {
        self.serverUrl = serverUrl;
        self.pathFormatter = pathFormatter;
        self.authorizationHeaderSupport = authorizationHeaderSupport;
        self.currentUserService = currentUserService;
    }
    return self;
}

- (AVPlayer *)playerForVideoId:(NSNumber *)videoId {
    NSString *path = [self.pathFormatter formatPath:API_VARIANT_PLAYLIST
                                        withVideoId:[videoId integerValue]];
    
    NSURL *videoURL = [NSURL URLWithString:path
                             relativeToURL:self.serverUrl];

    RTOAuth2Token *token = [self.currentUserService tokenForCurrentUser];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    
    if (token) {
        NSString *bearerToken = [self.authorizationHeaderSupport bearerTokenHeaderFromAccessToken:token.accessToken];
        [headers setObject:bearerToken forKey:RTAuthorizationHeader];
    }
    else {
        DDLogWarn(@"Missing token for streaming video!");
    }

    NSDictionary *options = @{AVURLAssetHTTPHeaderFieldsKey: headers};
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:options];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];

    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    return player;
}

- (AVPlayer *)playerForVideoURL:(NSURL *)videoURL {
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    return player;
}

@end
