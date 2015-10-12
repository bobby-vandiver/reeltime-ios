#import <Foundation/Foundation.h>

@class RTCurrentUserService;
@class RTPlayVideoIdExtractor;
@class RTAuthorizationHeaderSupport;

@protocol RTPlayVideoConnectionFactory;

@interface RTPlayVideoURLProtocol : NSURLProtocol

- (instancetype)initWithRequest:(NSURLRequest *)request
                 cachedResponse:(NSCachedURLResponse *)cachedResponse
                         client:(id<NSURLProtocolClient>)client
             currentUserService:(RTCurrentUserService *)currentUserService
              connectionFactory:(id<RTPlayVideoConnectionFactory>)connectionFactory
               videoIdExtractor:(RTPlayVideoIdExtractor *)videoIdExtractor
     authorizationHeaderSupport:(RTAuthorizationHeaderSupport *)authorizationHeaderSupport;

@end
