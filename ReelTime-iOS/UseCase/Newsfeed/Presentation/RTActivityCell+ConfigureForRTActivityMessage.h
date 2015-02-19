#import "RTActivityCell.h"

@class RTActivityMessage;
@protocol TTTAttributedLabelDelegate;

@interface RTActivityCell (ConfigureForRTActivityMessage)

- (void)configureForActivityMessage:(RTActivityMessage *)message
                  withLabelDelegate:(id<TTTAttributedLabelDelegate>)labelDelegate;

@end