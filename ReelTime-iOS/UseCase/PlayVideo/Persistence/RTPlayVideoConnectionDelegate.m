#import "RTPlayVideoConnectionDelegate.h"

#import "RTPlayVideoError.h"
#import "RTPlayVideoNotification.h"

#import "RTOAuth2TokenRenegotiator.h"

#import "RTErrorFactory.h"
#import "RTLogging.h"

@interface RTPlayVideoConnectionDelegate ()

@property NSURLProtocol *URLProtocol;
@property NSNotificationCenter *notifcationCenter;

@property RTOAuth2TokenRenegotiator *tokenRenegotiator;
@property (copy) NSNumber *videoId;

@end

@implementation RTPlayVideoConnectionDelegate

- (instancetype)initWithURLProtocol:(NSURLProtocol *)URLProtocol
                 notificationCenter:(NSNotificationCenter *)notificationCenter
                  tokenRenegotiator:(RTOAuth2TokenRenegotiator *)tokenRenegotiator
                         forVideoId:(NSNumber *)videoId {
    self = [super init];
    if (self) {
        self.URLProtocol = URLProtocol;
        self.notifcationCenter = notificationCenter;
        self.tokenRenegotiator = tokenRenegotiator;
        self.videoId = videoId;
    }
    return self;
}

#pragma mark - NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = httpResponse.statusCode;
    
    if (statusCode == 200) {
        [self.URLProtocol.client URLProtocol:self.URLProtocol
                          didReceiveResponse:response
                          cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    }
    else if (statusCode == 401) {
        DDLogWarn(@"Received an unauthorized response -- assuming token has expired");
        
        [connection cancel];
        
        [self.tokenRenegotiator renegotiateTokenWithCallback:^{
            [self.notifcationCenter postNotificationName:RTPlayVideoNotificationReloadVideo
                                                  object:self
                                                userInfo:@{RTPlayVideoNotificationVideoIdKey: self.videoId}];
        }];
    }
    else if (statusCode == 404) {
        DDLogWarn(@"Video [%@] not found", self.videoId);
        
        [connection cancel];
        
        NSError *error = [RTErrorFactory playVideoErrorWithCode:RTPlayVideoErrorVideoNotFound];
        [self.URLProtocol.client URLProtocol:self.URLProtocol didFailWithError:error];

        [self.notifcationCenter postNotificationName:RTPlayVideoNotificationVideoNotFound
                                              object:self
                                            userInfo:@{RTPlayVideoNotificationVideoIdKey: self.videoId}];
    }
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
