#import "RTTestCommon.h"

#import "RTPlayVideoIdExtractor.h"

SpecBegin(RTPlayVideoIdExtractor)

describe(@"play video id extractor", ^{

    __block RTPlayVideoIdExtractor *extractor;
    
    beforeEach(^{
        extractor = [[RTPlayVideoIdExtractor alloc] init];
    });
    
    describe(@"extract video id from url", ^{
        it(@"variant playlist", ^{
            NSURL *url = [NSURL URLWithString:@"http://localhost:8080/reeltime/api/playlists/1"];
            expect([extractor videoIdFromURL:url]).to.equal(@(1));
        });
        
        it(@"media playlist", ^{
            NSURL *url = [NSURL URLWithString:@"http://localhost:8080/reeltime/api/playlists/42/3"];
            expect([extractor videoIdFromURL:url]).to.equal(@(42));
        });
        
        it(@"segment", ^{
            NSURL *url = [NSURL URLWithString:@"http://localhost:8080/reeltime/api/playlists/831/441/10"];
            expect([extractor videoIdFromURL:url]).to.equal(@(831));
        });

        it(@"invalid", ^{
            NSURL *url1 = [NSURL URLWithString:@"http://localhost:8080/reeltime/api"];
            NSURL *url2 = [NSURL URLWithString:@"http://localhost:8080/reeltime/api/playlists/"];
            NSURL *url3 = [NSURL URLWithString:@"http://localhost:8080/reeltime/playlists/api"];
            NSURL *url4 = [NSURL URLWithString:@"http://localhost:8080/reeltime/api/playlists/foo"];
            NSURL *url5 = [NSURL URLWithString:@"http://localhost:8080/playlists/1"];

            expect([extractor videoIdFromURL:url1]).to.beNil();
            expect([extractor videoIdFromURL:url2]).to.beNil();
            expect([extractor videoIdFromURL:url3]).to.beNil();
            expect([extractor videoIdFromURL:url4]).to.beNil();
            expect([extractor videoIdFromURL:url5]).to.beNil();
        });
    });
});

SpecEnd
