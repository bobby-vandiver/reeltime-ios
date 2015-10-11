#import "RTPlayVideoURLProtocol.h"
#import "RTPlayVideoConnectionDelegate.h"

#import "RTPlayVideoAssembly.h"
#import "RTCurrentUserService.h"

#import "RTPlayVideoConnectionFactory.h"
#import "RTPlayVideoIdExtractor.h"

#import "RTAuthorizationHeaderSupport.h"

#import "RTRestAPI.h"
#import "RTOAuth2Token.h"

#import "RTLogging.h"

@interface RTPlayVideoURLProtocol ()

@property (nonatomic, strong) NSURLConnection *connection;

@property RTCurrentUserService *currentUserService;

@property RTPlayVideoConnectionFactory *connectionFactory;
@property RTPlayVideoIdExtractor *videoIdExtractor;

@property RTAuthorizationHeaderSupport *authorizationHeaderSupport;
@property NSNotificationCenter *notificationCenter;

@end

static NSString *const HandledKey = @"RTPlayVideoURLProtocolHandledKey";

@implementation RTPlayVideoURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSURL *url = request.URL;
    NSString *path = url.path;
    
    if ([path containsString:API_PLAYLIST]) {
        return ![NSURLProtocol propertyForKey:HandledKey inRequest:request];
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (instancetype)initWithRequest:(NSURLRequest *)request
                 cachedResponse:(NSCachedURLResponse *)cachedResponse
                         client:(id<NSURLProtocolClient>)client {
    
    RTPlayVideoAssembly *playVideoAssembly = [[RTPlayVideoAssembly assembly] activate];

    return [playVideoAssembly playVideoURLProtocolWithRequest:request
                                               cachedResponse:cachedResponse
                                                       client:client];
}

- (instancetype)initWithRequest:(NSURLRequest *)request
                 cachedResponse:(NSCachedURLResponse *)cachedResponse
                         client:(id<NSURLProtocolClient>)client
             currentUserService:(RTCurrentUserService *)currentUserService
              connectionFactory:(RTPlayVideoConnectionFactory *)connectionFactory
               videoIdExtractor:(RTPlayVideoIdExtractor *)videoIdExtractor
     authorizationHeaderSupport:(RTAuthorizationHeaderSupport *)authorizationHeaderSupport
             notificationCenter:(NSNotificationCenter *)notificationCenter {
    
    self = [super initWithRequest:request cachedResponse:cachedResponse client:client];
    if (self) {
        self.currentUserService = currentUserService;
        self.connectionFactory = connectionFactory;
        self.videoIdExtractor = videoIdExtractor;
        self.authorizationHeaderSupport = authorizationHeaderSupport;
        self.notificationCenter = notificationCenter;
    }
    return self;
}

- (void)startLoading {
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    
    RTOAuth2Token *token = [self.currentUserService tokenForCurrentUser];
    
    if (token) {
        NSString *bearerToken = [self.authorizationHeaderSupport bearerTokenHeaderFromAccessToken:token.accessToken];
        [newRequest setValue:bearerToken forHTTPHeaderField:RTAuthorizationHeader];
    }
    else {
        DDLogWarn(@"Missing token for streaming video!");
    }
    
    [NSURLProtocol setProperty:@(YES) forKey:HandledKey inRequest:newRequest];

    NSNumber *videoId = [self.videoIdExtractor videoIdFromURL:newRequest.URL];

    self.connection = [self.connectionFactory connectionWithRequest:newRequest
                                                     forURLProtocol:self
                                                 notificationCenter:self.notificationCenter
                                                            videoId:videoId];
}

- (void)stopLoading {
    [self.connection cancel];
    self.connection = nil;
}

@end
