#import "RTTestCommon.h"

#import "RTStringWithEmbeddedLinks.h"
#import "RTEmbeddedURL.h"

SpecBegin(RTStringWithEmbeddedLinks)

describe(@"string with embedded links", ^{
    
    __block RTStringWithEmbeddedLinks *string;
    
    __block NSURL *url1;
    __block NSURL *url2;
    
    beforeEach(^{
        string = [[RTStringWithEmbeddedLinks alloc] initWithString:@"this is a terrific test string"];
        
        url1 = [NSURL URLWithString:@"http://localhost:8080/somewhere"];
        url2 = [NSURL URLWithString:@"http://localhost:8080/anywhere"];
    });
    
    it(@"has no links", ^{
        NSArray *urls = [string embeddedURLs];
        expect(urls.count).to.equal(0);
    });
    
    it(@"do not add link if string not found", ^{
        [string addLinkToURL:url1 forString:@"unknown"];
        
        NSArray *urls = [string embeddedURLs];
        expect(urls.count).to.equal(0);
    });
    
    it(@"do not allow empty string to be linked", ^{
        [string addLinkToURL:url1 forString:@""];
        
        NSArray *urls = [string embeddedURLs];
        expect(urls.count).to.equal(0);
    });
    
    it(@"add one link", ^{
        [string addLinkToURL:url1 forString:@"this"];
        
        NSArray *urls = [string embeddedURLs];
        expect(urls.count).to.equal(1);
        
        RTEmbeddedURL *embeddedUrl = [urls objectAtIndex:0];
        expect(embeddedUrl.url).to.equal(url1);

        expect(embeddedUrl.range.location).to.equal(0);
        expect(embeddedUrl.range.length).to.equal(4);
    });
    
    it(@"add multiple links", ^{
        [string addLinkToURL:url1 forString:@"this"];
        [string addLinkToURL:url2 forString:@"terrific"];
        
        NSArray *urls = [string embeddedURLs];
        expect(urls.count).to.equal(2);
        
        RTEmbeddedURL *embeddedUrl = [urls objectAtIndex:0];
        expect(embeddedUrl.url).to.equal(url1);
        
        expect(embeddedUrl.range.location).to.equal(0);
        expect(embeddedUrl.range.length).to.equal(4);
        
        embeddedUrl = [urls objectAtIndex:1];
        expect(embeddedUrl.url).to.equal(url2);

        expect(embeddedUrl.range.location).to.equal(10);
        expect(embeddedUrl.range.length).to.equal(8);
    });
});

SpecEnd