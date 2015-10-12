#import <Foundation/Foundation.h>

@protocol RTPlayVideoConnectionFactory <NSObject>

- (NSURLConnection *)playVideoConnectionWithRequest:(NSURLRequest *)request
                                        URLProtocol:(NSURLProtocol *)URLProtocol
                                         forVideoId:(NSNumber *)videoId;

@end
