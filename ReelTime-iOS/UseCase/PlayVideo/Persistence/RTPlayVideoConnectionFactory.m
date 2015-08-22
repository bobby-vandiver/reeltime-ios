#import "RTPlayVideoConnectionFactory.h"
#import "RTPlayVideoConnectionDelegate.h"

@implementation RTPlayVideoConnectionFactory

- (NSURLConnection *)connectionWithRequest:(NSURLRequest *)request
                            forURLProtocol:(NSURLProtocol *)URLProtocol
                        notificationCenter:(NSNotificationCenter *)notificationCenter
                                   videoId:(NSNumber *)videoId {
    
    RTPlayVideoConnectionDelegate *delegate = [RTPlayVideoConnectionDelegate connectionDelegateForURLProtocol:URLProtocol
                                                                                            notificationCenter:notificationCenter
                                                                                                       videoId:videoId];
    
    return [NSURLConnection connectionWithRequest:request delegate:delegate];
}


@end
