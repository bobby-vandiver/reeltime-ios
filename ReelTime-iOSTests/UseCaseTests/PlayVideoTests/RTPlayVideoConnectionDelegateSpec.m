#import "RTTestCommon.h"

#import "RTPlayVideoConnectionDelegate.h"
#import "RTPlayVideoError.h"
#import "RTPlayVideoNotification.h"

#import "RTOAuth2TokenRenegotiator.h"

SpecBegin(RTPlayVideoConnectionDelegate)

describe(@"play video connection delegate", ^{
    
    __block RTPlayVideoConnectionDelegate *connectionDelegate;

    __block NSURLProtocol *urlProtocol;
    __block id<NSURLProtocolClient> urlProtocolClient;
    
    __block NSNotificationCenter *notificationCenter;
    __block NSURLConnection *connection;

    __block RTOAuth2TokenRenegotiator *tokenRenegotiator;
    
    beforeEach(^{
        notificationCenter = mock([NSNotificationCenter class]);
        urlProtocolClient = mockProtocol(@protocol(NSURLProtocolClient));

        urlProtocol = mock([NSURLProtocol class]);
        [given([urlProtocol client]) willReturn:urlProtocolClient];
        
        tokenRenegotiator = mock([RTOAuth2TokenRenegotiator class]);
        
        connectionDelegate = [[RTPlayVideoConnectionDelegate alloc] initWithURLProtocol:urlProtocol
                                                                     notificationCenter:notificationCenter
                                                                      tokenRenegotiator:tokenRenegotiator
                                                                             forVideoId:@(videoId)];
        
        connection = mock([NSURLConnection class]);
    });
    
    describe(@"receiving response", ^{
        __block NSURL *url;

        __block NSString *httpVersion;
        __block NSDictionary *headers;
        
        __block NSHTTPURLResponse *httpResponse;

        __block MKTArgumentCaptor *captor;
        
        beforeEach(^{
            url = [NSURL URLWithString:@"http://anywhere/"];
            httpVersion = @"HTTP/1.1";
            headers = @{};
            captor = [[MKTArgumentCaptor alloc] init];
        });
        
        context(@"successful response", ^{
            beforeEach(^{
                httpResponse = [[NSHTTPURLResponse alloc] initWithURL:url
                                                           statusCode:200
                                                          HTTPVersion:httpVersion
                                                         headerFields:headers];
            });
            
            it(@"should notify protocol client", ^{
                [connectionDelegate connection:connection didReceiveResponse:httpResponse];
                
                [verify(urlProtocolClient) URLProtocol:urlProtocol
                                    didReceiveResponse:httpResponse
                                    cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            });
        });
        
        context(@"unauthorized response", ^{
            __block MKTArgumentCaptor *callbackCaptor;
            
            beforeEach(^{
                httpResponse = [[NSHTTPURLResponse alloc] initWithURL:url
                                                           statusCode:401
                                                          HTTPVersion:httpVersion
                                                         headerFields:headers];
                
                [connectionDelegate connection:connection didReceiveResponse:httpResponse];
                
                callbackCaptor = [[MKTArgumentCaptor alloc] init];
            });
            
            it(@"should cancel connection", ^{
                [verify(connection) cancel];
            });
            
            it(@"should renegotiate token and publish notification on completion", ^{
                [verify(tokenRenegotiator) renegotiateTokenWithCallback:[callbackCaptor capture]];
                
                NoArgsCallback callback = callbackCaptor.value;
                callback();
                
                [verify(notificationCenter) postNotificationName:RTPlayVideoNotificationReloadVideo
                                                          object:connectionDelegate
                                                        userInfo:[captor capture]];
                
                NSDictionary *userInfo = captor.value;
                
                expect(userInfo).to.haveACountOf(1);
                expect(userInfo[RTPlayVideoNotificationVideoIdKey]).to.equal(@(videoId));
            });
        });
                
        context(@"video not found response", ^{
            beforeEach(^{
                httpResponse = [[NSHTTPURLResponse alloc] initWithURL:url
                                                           statusCode:404
                                                          HTTPVersion:httpVersion
                                                         headerFields:headers];

                [connectionDelegate connection:connection didReceiveResponse:httpResponse];
            });
            
            it(@"should cancel connection", ^{
                [verify(connection) cancel];
            });
            
            it(@"should notify protocol client of failure", ^{
                [verify(urlProtocolClient) URLProtocol:urlProtocol didFailWithError:[captor capture]];
                expect(captor.value).to.beError(RTPlayVideoErrorDomain, RTPlayVideoErrorVideoNotFound);
            });
            
            it(@"should publish notification", ^{
                [verify(notificationCenter) postNotificationName:RTPlayVideoNotificationVideoNotFound
                                                          object:connectionDelegate
                                                        userInfo:[captor capture]];
                
                NSDictionary *userInfo = captor.value;

                expect(userInfo).to.haveACountOf(1);
                expect(userInfo[RTPlayVideoNotificationVideoIdKey]).to.equal(@(videoId));
            });
        });
    });
    
    describe(@"receiving data", ^{
        it(@"should notify protocol client", ^{
            NSData *data = [NSData data];
            
            [connectionDelegate connection:connection didReceiveData:data];
            [verify(urlProtocolClient) URLProtocol:urlProtocol didLoadData:data];
        });
    });
    
    describe(@"finished loading", ^{
        it(@"should notify protocol client", ^{
            [connectionDelegate connectionDidFinishLoading:connection];
            [verify(urlProtocolClient) URLProtocolDidFinishLoading:urlProtocol];
        });
    });
    
    describe(@"connection failure", ^{
        it(@"should notify protocol client", ^{
            NSError *error = [NSError errorWithDomain:@"unknown" code:0 userInfo:nil];
            
            [connectionDelegate connection:connection didFailWithError:error];
            [verify(urlProtocolClient) URLProtocol:urlProtocol didFailWithError:error];
        });
    });
});

SpecEnd
