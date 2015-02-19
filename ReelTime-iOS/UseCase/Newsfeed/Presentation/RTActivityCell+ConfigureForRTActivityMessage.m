#import "RTActivityCell+ConfigureForRTActivityMessage.h"

#import "RTActivityMessage.h"
#import "RTStringWithEmbeddedLinks.h"
#import "RTEmbeddedURL.h"

@implementation RTActivityCell (ConfigureForRTActivityMessage)

- (void)configureForActivityMessage:(RTActivityMessage *)message
                  withLabelDelegate:(id<TTTAttributedLabelDelegate>)labelDelegate {
    self.icon.image = [self iconImageForType:message.type];

    self.label.delegate = labelDelegate;
    self.label.text = message.message.string;
    
    for (RTEmbeddedURL *link in message.message.links) {
        [self.label addLinkToURL:link.url withRange:link.range];
    }
}

- (UIImage *)iconImageForType:(RTActivityType)type {
    NSDictionary *iconImageNames = @{
                                     @(RTActivityTypeCreateReel): @"CreateReelIcon",
                                     @(RTActivityTypeJoinReelAudience): @"JoinReelAudienceIcon",
                                     @(RTActivityTypeAddVideoToReel): @"AddVideoToReelIcon"
                                     };

    NSString *imageName = iconImageNames[@(type)];
    return [UIImage imageNamed:imageName];
}

@end