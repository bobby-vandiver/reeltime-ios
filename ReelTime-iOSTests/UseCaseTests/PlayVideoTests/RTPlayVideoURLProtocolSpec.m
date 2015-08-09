#import "RTTestCommon.h"

#import "RTPlayVideoURLProtocol.h"

SpecBegin(RTPlayVideoURLProtocol)

describe(@"play video url protocol", ^{
    
    __block RTPlayVideoURLProtocol *protocol;
    
    __block NSURLRequest *request;
    __block NSCachedURLResponse *response;
    
    __block id<NSURLProtocolClient> protocolClient;
    
    
    beforeEach(^{
        request = mock([NSURLRequest class]);
        response = mock([NSCachedURLResponse class]);
        
        protocolClient = mockProtocol(@protocol(NSURLProtocolClient));
        
        protocol = [[RTPlayVideoURLProtocol alloc] initWithRequest:request
                                                    cachedResponse:response
                                                            client:protocolClient];
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
});

SpecEnd
