#import "RTPlayVideoURLProtocol.h"
#import "RTPlayVideoConnectionDelegate.h"

#import "RTServiceAssembly.h"
#import "RTCurrentUserService.h"

#import "RTAuthorizationHeaderSupport.h"

#import "RTOAuth2Token.h"
#import "RTLogging.h"

@interface RTPlayVideoURLProtocol ()

@property (nonatomic, strong) NSURLConnection *connection;

@property RTCurrentUserService *currentUserService;
@property RTAuthorizationHeaderSupport *authorizationHeaderSupport;

@end

static NSString *const HandledKey = @"RTPlayVideoURLProtocolHandledKey";

@implementation RTPlayVideoURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSURL *url = request.URL;
    NSString *path = url.path;
    
    if ([path containsString:@"/api/playlists/"]) {
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
    
    RTServiceAssembly *serviceAssembly = [[RTServiceAssembly assembly] activate];
    self.currentUserService = [serviceAssembly currentUserService];
 
    return [super initWithRequest:request cachedResponse:cachedResponse client:client];
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
    
    RTPlayVideoConnectionDelegate *delegate = [self createConnectionDelegate];
    self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:delegate];
}

- (RTPlayVideoConnectionDelegate *)createConnectionDelegate {
    // TODO: Extract videoId from request URL
    return [RTPlayVideoConnectionDelegate connectionDelegateForURLProtocol:self
                                                        notificationCenter:[NSNotificationCenter defaultCenter]
                                                                   videoId:nil];
}

- (void)stopLoading {
    [self.connection cancel];
    self.connection = nil;
}

@end
