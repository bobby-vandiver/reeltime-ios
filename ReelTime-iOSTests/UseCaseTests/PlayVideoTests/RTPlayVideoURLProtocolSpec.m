#import "RTTestCommon.h"

#import "RTPlayVideoURLProtocol.h"
#import "RTCurrentUserService.h"

#import "RTPlayVideoConnectionFactory.h"
#import "RTPlayVideoIdExtractor.h"

#import "RTAuthorizationHeaderSupport.h"
#import "RTOAuth2Token.h"

@interface RTPlayVideoURLProtocol (Test)

@property NSURLConnection *connection;

@end

SpecBegin(RTPlayVideoURLProtocol)

describe(@"play video url protocol", ^{
    
    __block RTPlayVideoURLProtocol *protocol;
    __block id<NSURLProtocolClient> client;
    
    __block NSURLRequest *request;
    __block NSCachedURLResponse *response;
    
    __block RTCurrentUserService *currentUserService;

    __block RTPlayVideoConnectionFactory *connectionFactory;
    __block RTPlayVideoIdExtractor *videoIdExtractor;
    
    __block RTAuthorizationHeaderSupport *authorizationHeaderSupport;
    __block NSNotificationCenter *notificationCenter;
    
    beforeEach(^{
        request = mock([NSURLRequest class]);
        response = mock([NSCachedURLResponse class]);
        
        client = mockProtocol(@protocol(NSURLProtocolClient));
        
        currentUserService = mock([RTCurrentUserService class]);

        connectionFactory = mock([RTPlayVideoConnectionFactory class]);
        videoIdExtractor = mock([RTPlayVideoIdExtractor class]);
        
        authorizationHeaderSupport = mock([RTAuthorizationHeaderSupport class]);
        notificationCenter = mock([NSNotificationCenter class]);
        
        protocol = [[RTPlayVideoURLProtocol alloc] initWithRequest:request
                                                    cachedResponse:response
                                                            client:client
                                                currentUserService:currentUserService
                                                 connectionFactory:connectionFactory
                                                  videoIdExtractor:videoIdExtractor
                                        authorizationHeaderSupport:authorizationHeaderSupport
                                                notificationCenter:notificationCenter];
    });
    
    describe(@"unsupported urls", ^{
        it(@"should not support non-playlist urls", ^{
            NSURL *url1 = [NSURL URLWithString:@"http://localhost:8080/reeltime/api/foo/1"];
            NSURL *url2 = [NSURL URLWithString:@"http://somewhere/api/foo/1"];
            NSURL *url3 = [NSURL URLWithString:@"http://localhost:8080/reeltime/api/reels/1"];
            NSURL *url4 = [NSURL URLWithString:@"http://localhost:8080/reeltime/api/videos/1"];
            NSURL *url5 = [NSURL URLWithString:@"http://localhost:8080/reeltime/api/videos/1/2"];
            NSURL *url6 = [NSURL URLWithString:@"http://localhost:8080/reeltime/api/videos/1/2/3"];
            
            NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
            NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
            NSURLRequest *request3 = [NSURLRequest requestWithURL:url3];
            NSURLRequest *request4 = [NSURLRequest requestWithURL:url4];
            NSURLRequest *request5 = [NSURLRequest requestWithURL:url5];
            NSURLRequest *request6 = [NSURLRequest requestWithURL:url6];
            
            expect([RTPlayVideoURLProtocol canInitWithRequest:request1]).to.beFalsy();
            expect([RTPlayVideoURLProtocol canInitWithRequest:request2]).to.beFalsy();
            expect([RTPlayVideoURLProtocol canInitWithRequest:request3]).to.beFalsy();
            expect([RTPlayVideoURLProtocol canInitWithRequest:request4]).to.beFalsy();
            expect([RTPlayVideoURLProtocol canInitWithRequest:request5]).to.beFalsy();
            expect([RTPlayVideoURLProtocol canInitWithRequest:request6]).to.beFalsy();
        });
    });
    
    describe(@"supported urls", ^{
        it(@"should support variant playlist", ^{
            NSURL *url1 = [NSURL URLWithString:@"http://localhost:8080/reeltime/api/playlists/1"];
            NSURL *url2 = [NSURL URLWithString:@"http://somewhere/api/playlists/1"];

            NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:url1];
            NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2];
            
            expect([RTPlayVideoURLProtocol canInitWithRequest:request1]).to.beTruthy();
            expect([RTPlayVideoURLProtocol canInitWithRequest:request2]).to.beTruthy();
            
            [NSURLProtocol setProperty:@(YES) forKey:@"RTPlayVideoURLProtocolHandledKey" inRequest:request1];
            [NSURLProtocol setProperty:@(YES) forKey:@"RTPlayVideoURLProtocolHandledKey" inRequest:request2];

            expect([RTPlayVideoURLProtocol canInitWithRequest:request1]).to.beFalsy();
            expect([RTPlayVideoURLProtocol canInitWithRequest:request2]).to.beFalsy();
        });
        
        it(@"should support media playlist", ^{
            NSURL *url1 = [NSURL URLWithString:@"http://localhost:8080/reeltime/api/playlists/1/2"];
            NSURL *url2 = [NSURL URLWithString:@"http://somewhere/api/playlists/1/2"];
            
            NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:url1];
            NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2];
            
            expect([RTPlayVideoURLProtocol canInitWithRequest:request1]).to.beTruthy();
            expect([RTPlayVideoURLProtocol canInitWithRequest:request2]).to.beTruthy();
            
            [NSURLProtocol setProperty:@(YES) forKey:@"RTPlayVideoURLProtocolHandledKey" inRequest:request1];
            [NSURLProtocol setProperty:@(YES) forKey:@"RTPlayVideoURLProtocolHandledKey" inRequest:request2];
            
            expect([RTPlayVideoURLProtocol canInitWithRequest:request1]).to.beFalsy();
            expect([RTPlayVideoURLProtocol canInitWithRequest:request2]).to.beFalsy();
        });
        
        it(@"should support media segment", ^{
            NSURL *url1 = [NSURL URLWithString:@"http://localhost:8080/reeltime/api/playlists/1/2/3"];
            NSURL *url2 = [NSURL URLWithString:@"http://somewhere/api/playlists/1/2/3"];
            
            NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:url1];
            NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2];
            
            expect([RTPlayVideoURLProtocol canInitWithRequest:request1]).to.beTruthy();
            expect([RTPlayVideoURLProtocol canInitWithRequest:request2]).to.beTruthy();
            
            [NSURLProtocol setProperty:@(YES) forKey:@"RTPlayVideoURLProtocolHandledKey" inRequest:request1];
            [NSURLProtocol setProperty:@(YES) forKey:@"RTPlayVideoURLProtocolHandledKey" inRequest:request2];
            
            expect([RTPlayVideoURLProtocol canInitWithRequest:request1]).to.beFalsy();
            expect([RTPlayVideoURLProtocol canInitWithRequest:request2]).to.beFalsy();
        });
    });
    
    describe(@"loading", ^{
        __block NSMutableURLRequest *mutableRequest;
        __block NSURLConnection *connection;
        
        beforeEach(^{
            mutableRequest = mock([NSMutableURLRequest class]);
            [given([request mutableCopy]) willReturn:mutableRequest];

            NSURL *url = mock([NSURL class]);
            
            [given([mutableRequest URL]) willReturn:url];
            [given([videoIdExtractor videoIdFromURL:url]) willReturn:@(videoId)];

            connection = mock([NSURLConnection class]);
            [given([connectionFactory connectionWithRequest:mutableRequest
                                             forURLProtocol:protocol
                                         notificationCenter:notificationCenter
                                                    videoId:@(videoId)]) willReturn:connection];
        });
        
        describe(@"starting", ^{
            it(@"should extract video id and create connection", ^{
                [protocol startLoading];
                [verify(connectionFactory) connectionWithRequest:mutableRequest
                                                  forURLProtocol:protocol
                                              notificationCenter:notificationCenter
                                                         videoId:@(videoId)];
                
                expect(protocol.connection).to.equal(connection);
            });
            
            context(@"token found for current user", ^{
                __block NSString *bearerTokenHeader = @"bearer";
                
                beforeEach(^{
                    RTOAuth2Token *token = [[RTOAuth2Token alloc] init];
                    token.accessToken = accessToken;
                    
                    [given([currentUserService tokenForCurrentUser]) willReturn:token];
                    [given([authorizationHeaderSupport bearerTokenHeaderFromAccessToken:accessToken]) willReturn:bearerTokenHeader];
                });
                
                it(@"should include bearer token in authorization header", ^{
                    [protocol startLoading];
                    [verify(mutableRequest) setValue:bearerTokenHeader forHTTPHeaderField:RTAuthorizationHeader];
                });
            });
            
            context(@"token not found for current user", ^{
                beforeEach(^{
                    [given([currentUserService tokenForCurrentUser]) willReturn:nil];
                });
                
                it(@"should not include bearer token in authorization header", ^{
                    [protocol startLoading];
                    [verifyCount(mutableRequest, never()) setValue:anything() forHTTPHeaderField:RTAuthorizationHeader];
                });
            });
        });

        describe(@"stopping", ^{
            it(@"should cancel the connection", ^{
                [protocol startLoading];
                [verify(connection) reset];
                
                [protocol stopLoading];
                [verify(connection) cancel];
                
                expect(protocol.connection).to.beNil();
            });
        });
    });
});

SpecEnd
