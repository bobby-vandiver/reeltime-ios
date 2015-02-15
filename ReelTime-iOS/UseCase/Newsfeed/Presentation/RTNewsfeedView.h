#import <Foundation/Foundation.h>
#import "RTActivityType.h"

@class RTActivityMessage;

@protocol RTNewsfeedView <NSObject>

- (void)showMessage:(RTActivityMessage *)message;

- (void)clearMessages;

@end
