#import "RTPlayVideoConnectionDelegate.h"
#import "RTLogging.h"

@interface RTPlayVideoConnectionDelegate ()

@property NSURLProtocol *URLProtocol;

@end

@implementation RTPlayVideoConnectionDelegate

+ (instancetype)connectionDelegateForURLProtocol:(NSURLProtocol *)URLProtocol {
    return [[RTPlayVideoConnectionDelegate alloc] initWithURLProtocol:URLProtocol];
}

- (instancetype)initWithURLProtocol:(NSURLProtocol *)URLProtocol {
    self = [super init];
    if (self) {
        self.URLProtocol = URLProtocol;
    }
    return self;
}

#pragma mark - NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    // TODO: Handle server errors
    DDLogDebug(@"status code = %ld", httpResponse.statusCode);
    
    [self.URLProtocol.client URLProtocol:self.URLProtocol didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.URLProtocol.client URLProtocol:self.URLProtocol didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.URLProtocol.client URLProtocolDidFinishLoading:self.URLProtocol];
}

#pragma mark - NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    DDLogError(@"Connection failed with error = %@", error);
    [self.URLProtocol.client URLProtocol:self.URLProtocol didFailWithError:error];
}

@end
