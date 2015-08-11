#import "RTPlayVideoURLProtocol.h"

#import "RTServiceAssembly.h"
#import "RTCurrentUserService.h"

#import "RTOAuth2Token.h"
#import "RTLogging.h"

@interface RTPlayVideoURLProtocol () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property RTCurrentUserService *currentUserService;

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
        // TODO: Refactor to use same code as HTTP client
        NSString *bearerToken = [NSString stringWithFormat:@"Bearer %@", token.accessToken];
        [newRequest setValue:bearerToken forKey:@"Authorization"];
    }
    else {
        DDLogWarn(@"Missing token for streaming video!");
    }
    
    [NSURLProtocol setProperty:@(YES) forKey:HandledKey inRequest:newRequest];
    self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
}

- (void)stopLoading {
    [self.connection cancel];
    self.connection = nil;
}

#pragma mark - NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

@end
