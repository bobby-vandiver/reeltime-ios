#import <Foundation/Foundation.h>

@interface RTPlayVideoConnectionDelegate : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

+ (instancetype)connectionDelegateForURLProtocol:(NSURLProtocol *)URLProtocol;

@end
