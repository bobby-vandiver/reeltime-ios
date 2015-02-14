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
        NSArray *links = [string links];
        expect(links.count).to.equal(0);
    });
    
    it(@"do not add link if string not found", ^{
        [string addLinkToURL:url1 forString:@"unknown"];
        
        NSArray *links = [string links];
        expect(links.count).to.equal(0);
    });
    
    it(@"do not allow empty string to be linked", ^{
        [string addLinkToURL:url1 forString:@""];
        
        NSArray *links = [string links];
        expect(links.count).to.equal(0);
    });
    
    it(@"add one link", ^{
        [string addLinkToURL:url1 forString:@"this"];
        
        NSArray *links = [string links];
        expect(links.count).to.equal(1);
        
        RTEmbeddedURL *link = [links objectAtIndex:0];
        expect(link.url).to.equal(url1);

        expect(link.range.location).to.equal(0);
        expect(link.range.length).to.equal(4);
    });
    
    it(@"add multiple links", ^{
        [string addLinkToURL:url1 forString:@"this"];
        [string addLinkToURL:url2 forString:@"terrific"];
        
        NSArray *links = [string links];
        expect(links.count).to.equal(2);
        
        RTEmbeddedURL *link = [links objectAtIndex:0];
        expect(link.url).to.equal(url1);
        
        expect(link.range.location).to.equal(0);
        expect(link.range.length).to.equal(4);
        
        link = [links objectAtIndex:1];
        expect(link.url).to.equal(url2);

        expect(link.range.location).to.equal(10);
        expect(link.range.length).to.equal(8);
    });
});

SpecEnd