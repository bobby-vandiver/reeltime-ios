#import <Foundation/Foundation.h>

@class RTCurrentUserService;
@class RTPlayVideoConnectionFactory;
@class RTPlayVideoIdExtractor;
@class RTAuthorizationHeaderSupport;

@interface RTPlayVideoURLProtocol : NSURLProtocol

- (instancetype)initWithRequest:(NSURLRequest *)request
                 cachedResponse:(NSCachedURLResponse *)cachedResponse
                         client:(id<NSURLProtocolClient>)client
             currentUserService:(RTCurrentUserService *)currentUserService
              connectionFactory:(RTPlayVideoConnectionFactory *)connectionFactory
               videoIdExtractor:(RTPlayVideoIdExtractor *)videoIdExtractor
     authorizationHeaderSupport:(RTAuthorizationHeaderSupport *)authorizationHeaderSupport
             notificationCenter:(NSNotificationCenter *)notificationCenter;

@end
