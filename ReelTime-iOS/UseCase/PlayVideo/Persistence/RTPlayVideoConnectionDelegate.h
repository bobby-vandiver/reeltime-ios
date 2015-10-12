#import <Foundation/Foundation.h>

@class RTOAuth2TokenRenegotiator;

@interface RTPlayVideoConnectionDelegate : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

- (instancetype)initWithURLProtocol:(NSURLProtocol *)URLProtocol
                 notificationCenter:(NSNotificationCenter *)notificationCenter
                  tokenRenegotiator:(RTOAuth2TokenRenegotiator *)tokenRenegotiator
                         forVideoId:(NSNumber *)videoId;

@end
