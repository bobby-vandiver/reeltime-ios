#import <Foundation/Foundation.h>

@class RTPlayVideoConnectionDelegate;

@interface RTPlayVideoConnectionFactory : NSObject

- (NSURLConnection *)connectionWithRequest:(NSURLRequest *)request
                            forURLProtocol:(NSURLProtocol *)URLProtocol
                        notificationCenter:(NSNotificationCenter *)notificationCenter
                                   videoId:(NSNumber *)videoId;

@end
