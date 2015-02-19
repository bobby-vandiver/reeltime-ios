#import "RTActivityCell.h"

@class RTActivityMessage;

@interface RTActivityCell (ConfigureForRTActivityMessage)

- (void)configureForActivityMessage:(RTActivityMessage *)message;

@end