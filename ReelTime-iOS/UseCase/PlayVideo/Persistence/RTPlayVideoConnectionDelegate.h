#import <Foundation/Foundation.h>

@interface RTPlayVideoConnectionDelegate : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

+ (instancetype)connectionDelegateForURLProtocol:(NSURLProtocol *)URLProtocol
                              notificationCenter:(NSNotificationCenter *)notificationCenter
                                         videoId:(NSNumber *)videoId;

@end
