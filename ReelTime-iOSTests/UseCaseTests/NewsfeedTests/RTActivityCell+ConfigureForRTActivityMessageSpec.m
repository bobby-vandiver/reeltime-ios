#import "RTTestCommon.h"

#import "RTActivityCell.h"
#import "RTActivityCell+ConfigureForRTActivityMessage.h"

#import "RTActivityMessage.h"

#import "RTStringWithEmbeddedLinks.h"
#import "RTEmbeddedURL.h"

SpecBegin(RTActivityCell_ConfigureForRTActivityMessage)

describe(@"activity cell configuration for activity message", ^{
    
    __block RTActivityCell *cell;
    
    __block id<TTTAttributedLabelDelegate> labelDelegate;
    __block RTStringWithEmbeddedLinks *stringWithLinks;
    
    NSString *const TEST_STRING = @"this is a test";
    
    beforeEach(^{
        stringWithLinks = [[RTStringWithEmbeddedLinks alloc] initWithString:TEST_STRING];
        labelDelegate = mockProtocol(@protocol(TTTAttributedLabelDelegate));
        
        cell = [[RTActivityCell alloc] init];

        cell.icon = [[UIImageView alloc] init];
        expect(cell.icon).toNot.beNil();

        cell.label = [[TTTAttributedLabel alloc] init];
        expect(cell.label).toNot.beNil();
    });

    describe(@"configuring icon image", ^{
        it(@"should set icon for create reel message", ^{
            RTActivityMessage *message = [RTActivityMessage activityMessage:stringWithLinks withType:RTActivityTypeCreateReel];
            
            [cell configureForActivityMessage:message withLabelDelegate:labelDelegate];
            expect(cell.icon.image).to.equal([UIImage imageNamed:@"CreateReelIcon"]);
        });
        
        it(@"should set icon for join reel audience message", ^{
            RTActivityMessage *message = [RTActivityMessage activityMessage:stringWithLinks withType:RTActivityTypeJoinReelAudience];
            
            [cell configureForActivityMessage:message withLabelDelegate:labelDelegate];
            expect(cell.icon.image).to.equal([UIImage imageNamed:@"JoinReelAudienceIcon"]);
        });
        
        it(@"should set icon for add video to reel message", ^{
            RTActivityMessage *message = [RTActivityMessage activityMessage:stringWithLinks withType:RTActivityTypeAddVideoToReel];
            
            [cell configureForActivityMessage:message withLabelDelegate:labelDelegate];
            expect(cell.icon.image).to.equal([UIImage imageNamed:@"AddVideoToReelIcon"]);
        });
    });
    
    describe(@"configuring label", ^{
        __block RTActivityMessage *message;
        
        NSURL *url1 = [NSURL URLWithString:@"test://url1"];
        NSURL *url2 = [NSURL URLWithString:@"test://url2"];

        beforeEach(^{
            message = [RTActivityMessage activityMessage:stringWithLinks withType:RTActivityTypeCreateReel];
        });
        
        it(@"should set label delegate", ^{
            [cell configureForActivityMessage:message withLabelDelegate:labelDelegate];
            expect(cell.label.delegate).to.equal(labelDelegate);
        });
        
        it(@"should handle a message with no links", ^{
            [cell configureForActivityMessage:message withLabelDelegate:labelDelegate];
            expect(cell.label.text).to.equal(TEST_STRING);
        });
        
        it(@"should handle a message with one link", ^{
            [stringWithLinks addLinkToURL:url1 forString:@"is"];
            [cell configureForActivityMessage:message withLabelDelegate:labelDelegate];

            expect(cell.label.text).to.equal(TEST_STRING);
            expect(cell.label.links.count).to.equal(1);
            
            NSTextCheckingResult *link = [cell.label.links objectAtIndex:0];
            expect(link.URL).to.equal(url1);

            NSString *linkText = [stringWithLinks.string substringWithRange:link.range];
            expect(linkText).to.equal(@"is");
        });
        
        it(@"should handle a message with multiple links", ^{
            [stringWithLinks addLinkToURL:url1 forString:@"is"];
            [stringWithLinks addLinkToURL:url2 forString:@"test"];
            
            [cell configureForActivityMessage:message withLabelDelegate:labelDelegate];
            
            expect(cell.label.text).to.equal(TEST_STRING);
            expect(cell.label.links.count).to.equal(2);
            
            NSTextCheckingResult *link = [cell.label.links objectAtIndex:0];
            expect(link.URL).to.equal(url1);
            
            NSString *linkText = [stringWithLinks.string substringWithRange:link.range];
            expect(linkText).to.equal(@"is");
            
            link = [cell.label.links objectAtIndex:1];
            expect(link.URL).to.equal(url2);
            
            linkText = [stringWithLinks.string substringWithRange:link.range];
            expect(linkText).to.equal(@"test");
        });
    });
});

SpecEnd