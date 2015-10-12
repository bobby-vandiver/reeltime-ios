#import <Foundation/Foundation.h>

@interface RTPlayVideoConnectionDelegate : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

- (instancetype)initWithURLProtocol:(NSURLProtocol *)URLProtocol
                 notificationCenter:(NSNotificationCenter *)notificationCenter
                         forVideoId:(NSNumber *)videoId;

@end
